# Application-LOGIC and Agents-LOGIC

This document explains, briefly and practically, how the Streamlit application logic and Azure AI Foundry agent logic work in this project.

The project has two Streamlit app files:

- `app.py`: multi-application portal with HR, IT, and ServiceNow apps, plus auto-routing to domain agent IDs.
- `app2.py`: multi-application portal using one shared Foundry agent, tenant-aware Azure authentication, small-talk detection, and stronger uploaded-document retrieval.

The main user experience is the same in both files: the user selects an app, optionally uploads a document, asks a question, and receives either an Azure AI Foundry response or a local fallback response.

## 1. High-Level Block Diagram

```mermaid
flowchart LR
    User[User] --> UI[Streamlit UI]
    UI --> State[Session State]
    UI --> Upload[Uploaded Context]
    UI --> Config[Environment Config]
    Config --> AzureAuth[Azure Credential]
    AzureAuth --> Foundry[Azure AI Foundry Agent]
    Upload --> PromptBuilder[Prompt Builder]
    State --> PromptBuilder
    UI --> PromptBuilder
    PromptBuilder --> Foundry
    Foundry --> Response[Agent Response]
    PromptBuilder --> Fallback[Local Fallback Logic]
    Fallback --> Response
    Response --> UI
```

## 2. Application-LOGIC

Application logic means everything the Streamlit app does before and after the AI agent is called.

### Step-by-Step Application Flow

1. Load environment variables from `.env`.
2. Define application settings in `APP_CONFIGS`.
3. Start Streamlit and apply EY-style UI CSS.
4. Initialize `st.session_state` for:
   - active app
   - chat messages
   - uploaded document text
   - uploaded document file names
   - Foundry thread IDs
5. Show sidebar controls:
   - application selector
   - agent details
   - project endpoint
   - deployment/model details
   - file uploader
   - clear chat button
6. Render the main portal header and active app panel.
7. Show quick prompt buttons for common HR, IT, and ServiceNow tasks.
8. Display chat history for the active app.
9. Read user input from `st.chat_input`.
10. Build the correct prompt for the selected app.
11. Call Azure AI Foundry agent.
12. If Azure fails, use local fallback logic.
13. Save assistant response back into session state.

### Application Flowchart

```mermaid
flowchart TD
    A[Start Streamlit App] --> B[Load .env]
    B --> C[Create App Configs]
    C --> D[Initialize Session State]
    D --> E[Render Sidebar and Main UI]
    E --> F{User Uploads File?}
    F -- Yes --> G[Extract Text from PDF DOCX TXT MD CSV]
    F -- No --> H[Keep Existing Context]
    G --> I[Store Context in Session State]
    H --> J[Wait for Chat Input]
    I --> J
    J --> K{User Sends Prompt?}
    K -- No --> E
    K -- Yes --> L[Add User Message to Chat History]
    L --> M[Build Agent Prompt]
    M --> N[Call Azure AI Foundry]
    N --> O{Agent Call Success?}
    O -- Yes --> P[Display Agent Answer]
    O -- No --> Q[Use Local Fallback Answer]
    Q --> P
    P --> R[Save Assistant Message]
    R --> E
```

## 3. App Modes

The portal supports three domain applications.

| App | Purpose | Typical Questions |
| --- | --- | --- |
| HR App | Employee support and HR process guidance | Leave, onboarding, benefits, payroll, policies |
| IT Helpdesk App | Technical support and access help | Laptop, VPN, password, MFA, software, email |
| ServiceNow Ticketing App | Ticket drafting and ITSM notes | Incidents, priority, assignment notes, resolution notes |

Each app has its own:

- title and caption
- chat placeholder
- initial assistant message
- uploaded document context
- chat history
- quick prompts
- fallback responses

## 4. Uploaded Document Logic

The user can upload documents for app-specific context.

Supported file types:

- `.pdf`
- `.docx`
- `.txt`
- `.md`
- `.csv`

### Document Processing Steps

1. User uploads a file in the sidebar.
2. App checks file extension.
3. App extracts text:
   - text-like files are decoded directly
   - PDF files are read with `pypdf`
   - DOCX files are read from `word/document.xml`
4. Extracted text is saved in `st.session_state.app_contexts`.
5. If the uploaded file changed, the previous Foundry thread for that app is cleared.
6. The document text is added to the agent prompt when relevant.

### Document Context Flow

```mermaid
flowchart TD
    A[Upload File] --> B{File Type}
    B -->|TXT MD CSV| C[Decode Bytes]
    B -->|PDF| D[Read Pages with pypdf]
    B -->|DOCX| E[Read word/document.xml]
    C --> F[Extracted Text]
    D --> F
    E --> F
    F --> G[Save in Session State]
    G --> H[Attach to Agent Prompt]
    H --> I[Agent Answers from Context]
```

## 5. Agents-LOGIC

Agent logic means how the app decides what instructions and context are sent to Azure AI Foundry, how the Foundry thread is managed, and how responses are returned.

### Agent Call Steps

1. Build app-specific instructions from `APP_CONFIGS`.
2. Add uploaded document context if available.
3. Add the selected application name.
4. Add the user's latest request.
5. Get or create a Foundry thread ID for the active app.
6. Create a user message in the Foundry thread.
7. Run the configured Foundry agent.
8. Read assistant messages from the thread.
9. Return the latest assistant message to the Streamlit UI.

### Agent Flowchart

```mermaid
flowchart TD
    A[User Prompt] --> B[Build Agent Prompt]
    B --> C[Get or Create Foundry Thread]
    C --> D[Create User Message in Thread]
    D --> E[Create and Process Agent Run]
    E --> F{Run Status}
    F -- Completed --> G[List Thread Messages]
    F -- Failed --> H[Raise Error]
    G --> I[Pick Latest Assistant Message]
    I --> J[Return Answer to UI]
    H --> K[Fallback Logic]
    K --> J
```

## 6. Difference Between `app.py` and `app2.py`

### `app.py`

`app.py` is designed for domain-agent routing.

Important functions:

- `route_app()`: scores the user prompt against HR, IT, and ServiceNow keywords.
- `build_agent_prompt()`: combines app instructions, uploaded context, and user question.
- `ask_foundry_agent()`: sends the prompt to Azure AI Foundry and returns the answer.
- `fallback_answer()`: gives local guidance if Azure is not available.

Routing behavior:

```mermaid
flowchart TD
    A[User Prompt] --> B[Extract Prompt Words]
    B --> C[Compare with HR IT SN Keywords]
    C --> D{Best Matching App Found?}
    D -- Yes --> E[Route to Matching Domain App]
    D -- No --> F[Use Current Selected App]
    E --> G[Use That App Agent ID]
    F --> G
    G --> H[Call Foundry Agent]
```

### `app2.py`

`app2.py` is designed for one shared Foundry agent with stronger local control.

Important functions:

- `build_azure_credential()`: chooses tenant-aware Azure authentication.
- `is_small_talk()`: detects greetings and avoids unnecessary Azure calls.
- `retrieve_relevant_context()`: finds useful uploaded document chunks.
- `uploaded_context_answer()`: answers from uploaded context when possible.
- `build_agent_prompt()`: gives strict rules to avoid inventing policy/SOP details.
- `ask_foundry_agent()`: runs the Azure AI Foundry agent.

Small-talk and context behavior:

```mermaid
flowchart TD
    A[User Prompt] --> B{Small Talk?}
    B -- Yes --> C[Return Friendly Local Reply]
    B -- No --> D{Uploaded Context Exists?}
    D -- Yes --> E[Retrieve Relevant Sections or Chunks]
    D -- No --> F[Build Generic App Prompt]
    E --> G[Build Strict Context Prompt]
    F --> H[Call Shared Foundry Agent]
    G --> H
    H --> I{Azure Success?}
    I -- Yes --> J[Return Agent Answer]
    I -- No --> K[Use Local Fallback]
    K --> J
```

## 7. Prompt Construction Logic

The prompt sent to the agent contains four main parts.

```text
1. System-style app instructions
2. Uploaded document context, if available
3. Active application name
4. User request
```

Example structure:

```text
You are a precise enterprise assistant.
Follow the application rules.

Application-specific instruction:
HR / IT / ServiceNow behavior

Uploaded document context:
Relevant extracted text

Application:
HR App

User request:
Explain the leave policy
```

## 8. Fallback Logic

Fallback logic keeps the app useful even if Azure authentication, permissions, network, or Foundry run execution fails.

Fallback can happen when:

- Azure login is missing or expired.
- Tenant or RBAC permission is incorrect.
- Foundry agent run fails.
- No assistant message is returned.
- Local machine cannot reach the Foundry project.

Fallback response types:

- HR: leave, onboarding, benefits, HR email draft.
- IT: VPN, password/account lockout, software/access request.
- ServiceNow: ticket draft, classification, resolution note.
- Uploaded document: matching excerpts from uploaded context.

## 9. Complete Runtime Sequence

```mermaid
sequenceDiagram
    participant U as User
    participant S as Streamlit App
    participant SS as Session State
    participant A as Azure AI Foundry
    participant F as Fallback Logic

    U->>S: Select app / upload file
    S->>SS: Save active app and context
    U->>S: Send chat prompt
    S->>SS: Save user message
    S->>S: Build app-specific prompt
    S->>A: Create message and process run
    alt Foundry succeeds
        A-->>S: Assistant answer
    else Foundry fails
        S->>F: Create local fallback answer
        F-->>S: Fallback answer
    end
    S->>SS: Save assistant message
    S-->>U: Display response
```

## 10. Simple Mental Model

Think of the project in three layers:

```text
UI Layer
  Streamlit screens, sidebar, file upload, chat display

Application Layer
  App selection, session state, document extraction, routing, fallback

Agent Layer
  Prompt building, Azure credential, Foundry thread, agent run, assistant response
```

In short:

- Streamlit manages the user experience.
- `APP_CONFIGS` defines the three app personalities.
- Session state remembers each app's chat and document context.
- Uploaded files provide extra source material.
- Azure AI Foundry generates the main response.
- Local fallback logic protects the demo when the cloud agent is unavailable.

