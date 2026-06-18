

/*1. Employee Table */
 
CREATE TABLE dbo.Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeCode VARCHAR(20),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    DepartmentID INT,
    JobTitle VARCHAR(100),
    ManagerID INT NULL,
    HireDate DATE,
    Salary DECIMAL(12,2),
    City VARCHAR(50),
    Status VARCHAR(20)
);


/*2. Insert Sample data into Employee Table */
 
INSERT INTO dbo.Employee
(EmployeeCode, FirstName, LastName, Email, Phone, DepartmentID, JobTitle, ManagerID, HireDate, Salary, City, Status)
VALUES
('EMP001','Sandeep','Kumar','sandeep@contoso.com','9876543210',1,'HR Manager',NULL,'2021-01-10',120000,'Bangalore','Active'),
('EMP002','Anita','Sharma','anita@contoso.com','9876543211',2,'Software Engineer',4,'2022-03-15',85000,'Hyderabad','Active'),
('EMP003','Rahul','Verma','rahul@contoso.com','9876543212',2,'Senior Developer',4,'2020-06-20',110000,'Pune','Active'),
('EMP004','Priya','Reddy','priya@contoso.com','9876543213',2,'Engineering Manager',NULL,'2019-02-01',150000,'Bangalore','Active'),
('EMP005','Arjun','Patel','arjun@contoso.com','9876543214',3,'Finance Analyst',6,'2023-01-18',70000,'Mumbai','Active'),
('EMP006','Neha','Gupta','neha@contoso.com','9876543215',3,'Finance Manager',NULL,'2018-07-11',135000,'Delhi','Active'),
('EMP007','Kiran','Das','kiran@contoso.com','9876543216',4,'Sales Executive',8,'2022-05-12',65000,'Chennai','Active'),
('EMP008','Meera','Nair','meera@contoso.com','9876543217',4,'Sales Manager',NULL,'2019-08-08',140000,'Bangalore','Active');



/*Add more Employees to Trigger Copilot Agent */

INSERT INTO dbo.Employee
(EmployeeCode, FirstName, LastName, Email, Phone, DepartmentID, JobTitle, ManagerID, HireDate, Salary, City, Status)
VALUES
('EMP009','Vikram','Singh','vikram@contoso.com','9876543218',2,'Software Engineer',4,'2023-04-10',90000,'Bangalore','Active'),

('EMP010','Pooja','Mehta','pooja@contoso.com','9876543219',2,'QA Engineer',4,'2022-11-15',80000,'Hyderabad','Active'),

('EMP011','Rohit','Agarwal','rohit@contoso.com','9876543220',2,'DevOps Engineer',4,'2021-08-20',115000,'Pune','Active'),

('EMP012','Sneha','Joshi','sneha@contoso.com','9876543221',1,'HR Executive',1,'2024-01-05',60000,'Bangalore','Active'),

('EMP013','Amit','Kulkarni','amit@contoso.com','9876543222',3,'Accountant',6,'2022-09-12',75000,'Mumbai','Active'),

('EMP014','Divya','Iyer','divya@contoso.com','9876543223',3,'Financial Analyst',6,'2023-02-28',85000,'Chennai','Active'),

('EMP015','Nikhil','Bose','nikhil@contoso.com','9876543224',4,'Sales Executive',8,'2024-03-15',62000,'Kolkata','Active'),

('EMP016','Ritika','Kapoor','ritika@contoso.com','9876543225',4,'Senior Sales Executive',8,'2021-12-01',95000,'Delhi','Active'),

('EMP017','Manoj','Rao','manoj@contoso.com','9876543226',5,'Operations Analyst',NULL,'2023-07-11',78000,'Bangalore','Active'),

('EMP018','Kavya','Menon','kavya@contoso.com','9876543227',5,'Operations Manager',17,'2020-05-25',125000,'Hyderabad','Active'),

('EMP019','Suresh','Nair','suresh@contoso.com','9876543228',2,'Data Engineer',4,'2022-04-18',105000,'Chennai','Active'),

('EMP020','Asha','Thomas','asha@contoso.com','9876543229',2,'Data Scientist',4,'2021-10-30',135000,'Bangalore','Active');
