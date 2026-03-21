# 🧱 Phase 1 — Manual 3-Tier Deployment (Terminal-Driven)

## 📌 Objective

This phase demonstrates how to deploy and run a complete **3-tier application manually**, without automation tools or CI/CD pipelines.

The goal is to deeply understand:

* How services start and depend on each other
* How different tiers communicate via network ports
* How to debug failures using terminal tools

> ⚠️ No automation, no containers, no pipelines — only manual control using shell.

---

## 🏗️ Architecture

```
Browser → Frontend (React) → Backend (Spring Boot) → Database (MySQL)
```

---

## 🎯 End Goal

By completing this phase, you will be able to:

* Run all 3 tiers manually from the terminal
* Connect frontend → backend → database successfully
* Verify communication using CLI tools
* Debug common failures (DB down, port conflicts, wrong configs)

---

## 🧰 Prerequisites

Install required tools:

```bash
sudo apt update
sudo apt install openjdk-17-jdk mysql-server nodejs npm net-tools curl
```

Verify installation:

```bash
java -version
node -v
mysql --version
```

---

## 📁 Project Structure

```
phase-1-manual/
├── backend/
├── frontend/
└── database/
```

---

## 🪜 Step-by-Step Execution

---

### 🔹 Step 1 — Start Database (MySQL)

Start MySQL service:

```bash
sudo service mysql start
```

Login as root:

```bash
mysql -u root -p
```

Create database and user:

```sql
CREATE DATABASE helpapp;

CREATE USER 'appuser'@'localhost' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON helpapp.* TO 'appuser'@'localhost';

FLUSH PRIVILEGES;
```

Test connection:

```bash
mysql -u appuser -p helpapp
```

---

### 🔹 Step 2 — Run Backend (Spring Boot)

Navigate to backend:

```bash
cd backend
```

Configure database in `application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/helpapp
spring.datasource.username=appuser
spring.datasource.password=password
```

Build the application:

```bash
./mvnw clean package
```

Run the backend:

```bash
java -jar target/app.jar
```

Verify backend is running:

```bash
curl http://localhost:8080
```

---

### 🔹 Step 3 — Run Frontend (React)

Navigate to frontend:

```bash
cd ../frontend
```

Install dependencies:

```bash
npm install
```

Start frontend:

```bash
npm start
```

Access in browser:

```
http://localhost:3000
```

---

### 🔹 Step 4 — Connect Frontend to Backend

Ensure API calls point to backend:

```javascript
fetch("http://localhost:8080/api")
```

Verify:

* Frontend loads
* API calls succeed

---

## 🔍 Verification & Debugging

Check running services:

```bash
netstat -tulnp
```

Test backend manually:

```bash
curl http://localhost:8080/api
```

Check database access:

```bash
mysql -u appuser -p helpapp
```

---

## 💥 Failure Testing (Important)

Simulate failures to understand system behavior:

### 1. Stop Database

```bash
sudo service mysql stop
```

👉 Backend should fail

---

### 2. Wrong DB Credentials

* Modify password in config
  👉 Observe connection errors

---

### 3. Kill Backend Process

```bash
ps aux | grep java
kill -9 <pid>
```

👉 Frontend API calls fail

---

### 4. Port Conflict

Run another service on 8080
👉 Backend fails to start

---

## 🔐 Basic Security Awareness

Scan open ports:

```bash
nmap localhost
```

Observe:

* Open ports (3000, 8080, 3306)
* Exposed services

---

## 🧠 Key Learnings

* Services must start in correct order (DB → Backend → Frontend)
* Backend depends on database availability
* Communication happens via ports
* Failures propagate across tiers
* Manual setups are error-prone and not scalable

---

## 🚧 Limitations of This Approach

* No automation
* No scalability
* High manual effort
* No built-in security controls

---

## 🚀 Next Phase

➡️ Phase 2 — Shell Automation

In the next phase, we will:

* Convert manual steps into scripts
* Automate setup and deployment
* Reduce human error

---

## 📌 Summary

This phase builds a strong foundation by exposing:

* real system behavior
* real failure scenarios
* real debugging techniques

> “Before automating systems, you must understand how they break.”
