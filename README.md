# HRDesk - HR Management System

A Java-based HR management web application built with Jakarta Servlets, JSP, and MySQL.

## Features
- Employee Management (Add/Edit/Delete/View)
- Attendance Tracking
- Leave Management with Approvals
- Payroll Generation
- Support Ticket System
- Role-based access (Admin / Employee)

## Prerequisites
- Java 17+
- Apache Tomcat 10+
- MySQL 8+
- Eclipse IDE (recommended) or any Jakarta EE compatible IDE

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd HR_CONSULTANT
```

### 2. Create the Database
Run the SQL schema file in your MySQL to create the database and all tables:

```bash
mysql -u root -p < src/main/resources/schema.sql
```

This will create:
- `hrdesk_db` database
- All 6 tables (`departments`, `employees`, `attendance`, `leave_requests`, `payroll`, `support_tokens`)
- Seed data with default departments and an admin user

> **Note:** The `role` and `designation` columns are part of the `employees` table. The `role` column (ADMIN/EMPLOYEE) controls what pages a user can access, and `designation` stores the job title (e.g. Software Engineer).

### 3. Update Database Credentials

Open `src/main/java/com/hrdesk/utility/Connector.java` and update the `PASSWORD` to match your local MySQL password:

```java
private static final String URL = "jdbc:mysql://localhost:3306/hrdesk_db";
private static final String DB_USER = "root";
private static final String PASSWORD = "your-mysql-password";  // ← Change this
```

### 4. Deploy in Eclipse
1. Import project: `File → Import → Existing Maven Projects` (or `Existing Web Projects`)
2. Right-click project → `Properties → Target Runtimes` → Select Apache Tomcat 10
3. Right-click project → `Run As → Run on Server`

### 5. Access the Application
- **URL:** `http://localhost:8080/HR_CONSULTANT`
- **Default Admin Login:**
  - Email: `admin@hrdesk.com`
  - Password: `admin123`

### 6. (Optional) Register New Employees
Other users can register via the public registration page, which creates EMPLOYEE accounts.

## Database Tables

| Table            | Description            | Key Columns                               |
|------------------|------------------------|-------------------------------------------|
| `departments`    | Company departments    | `dept_id`, `dept_name`, `location`        |
| `employees`      | All users & employees  | `emp_id`, `role`, `designation`, `email`  |
| `attendance`     | Daily attendance logs  | `att_id`, `emp_id`, `date`, `status`      |
| `leave_requests` | Leave applications     | `leave_id`, `emp_id`, `status`            |
| `payroll`        | Salary records         | `payroll_id`, `emp_id`, `net_salary`      |
| `support_tokens` | IT support tickets     | `token_id`, `emp_id`, `status`            |

## Troubleshooting

**Error: Table 'hrdesk_db.employees' doesn't exist**
→ Run `src/main/resources/schema.sql` to create all tables.

**Error: Unknown column 'role' or 'designation'**
→ Make sure you ran the schema.sql and not just created an empty database. The `role` and `designation` columns are defined in the `employees` table.

**Error: Connection refused / Access denied**
→ Check MySQL is running. Verify username/password in `Connector.java`.

---

Built with ❤️ using Jakarta EE, Servlets, JSP, and MySQL.
# HR_CONSULTANT
# Pipeline test
