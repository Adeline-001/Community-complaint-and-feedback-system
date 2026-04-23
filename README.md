# Citizen Voice - Community Complaint System

A premium Java web application for managing community complaints and administrative resolutions.

## 🚀 Features
- **Modern UI**: State-of-the-art Glassmorphism design.
- **Role-Based Access**: Separate dashboards for Citizens and Administrators.
- **Complaint Lifecycle**: Track issues from 'Pending' to 'Resolved'.
- **Admin Command Center**: Search, filter, and manage all community data.
- **Security**: Robust session management and password hashing.

## 🛠️ Tech Stack
- **Backend**: Java Servlets, JSP
- **Frontend**: Vanilla CSS, FontAwesome
- **Database**: MySQL
- **Build**: Maven

## ⚙️ Local Setup

### 1. Database Configuration
1. Open MySQL Workbench.
2. Execute the script found in `database_setup.sql`.
3. Update `src/main/java/com/example/util/DBConnection.java` with your database credentials (username/password).

### 2. Run the Application
1. Open the project in IntelliJ IDEA.
2. Ensure you have a **Tomcat 10.1+** server configured.
3. Build the project: `mvn clean install`
4. Deploy to Tomcat and run.

## 👤 Test Credentials
- **Admin**: `admin@example.com` / `admin123`
- **Citizen**: Register a new account on the landing page.

## 👥 Contributors
- Developed as a practical project for [User Name]

---
*Developed with ❤️ for the Community.*
