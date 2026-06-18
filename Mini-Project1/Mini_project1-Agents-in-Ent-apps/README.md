# Accenture AI Agent Apps Portal

Streamlit multi-application portal for an Accenture client AI project, integrated with Azure AI Foundry:

- Project endpoint: `https://sandeepfoundry2314.services.ai.azure.com/api/projects/proj-default`
- Agent endpoint: `.../agents/sandeepagent111/endpoint/protocols/openai/responses`
- Agent name: `sandeepagent111`
- Model deployment: `grok-4.3`
- MCP server: `Microsoft Learn MCP server`
- Foundry API version: `v1`
- Foundry auth mode: `entra` for agents/tools that require OBO authentication

## Applications

- HR App: leave, onboarding, benefits, policies, and people support.
- IT Helpdesk App: laptop, VPN, password, software, access, cloud, and productivity support.
- ServiceNow Ticketing App: incident drafts, classifications, assignment notes, and resolution notes.

Each application has its own chat history, uploaded context, quick prompts, and fallback guidance. `app.py` supports keyword-based routing between the three domains. `app2.py` keeps the stricter uploaded-document retrieval flow for policy/SOP answers.

The interface now uses an Accenture-inspired professional theme with black surfaces, purple accents, the "Let there be change" message, and reinvention-oriented copy.

## Setup

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Copy `.env.example` to `.env`. For hosted agents with OBO-authenticated tools, keep `FOUNDRY_AUTH_MODE=entra` and sign in with Azure CLI or browser auth. Use `FOUNDRY_AUTH_MODE=api_key` only for agents whose tools support API-key authentication.

## Run

```powershell
streamlit run app.py
streamlit run app2.py
```

Open:

```text
http://localhost:8501
```

If the Foundry responses endpoint is unavailable, the apps continue running with local uploaded-document guidance and domain-specific fallback responses.
