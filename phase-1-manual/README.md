
# 📘 Phase 1: Manual Setup (3-Tier DevSecOps Project)

## 🎯 Goal

In this phase, we manually set up a basic **3-tier architecture** to understand how everything works before automating.

We will:

* Provision infrastructure manually
* Configure servers step-by-step
* Deploy the application without automation
* Understand networking, access, and dependencies

---

## 🏗️ Architecture Overview

**3-Tier Architecture:**

1. **Web Layer (Frontend / Nginx / React)**
2. **App Layer (Backend / Spring Boot API)**
3. **Database Layer (MySQL)**

```
User → Web Server → App Server → Database Server
```

---

## 🧰 Prerequisites

* AWS Account (or any cloud)
* Basic Linux knowledge
* SSH access setup
* Key pair (.pem file)
* Git installed

---

## 🚀 Steps

### 1️⃣ Create Infrastructure (Manually)

* Launch 3 EC2 instances:

  * Web Server
  * App Server
  * DB Server

* Configure:

  * Security Groups:

    * Allow SSH (22)
    * HTTP (80) for Web Server
    * App Port (8080)
    * MySQL Port (3306) (restricted)

---

### 2️⃣ Connect to Servers

```bash
ssh -i your-key.pem ubuntu@<server-ip>
```

---

### 3️⃣ Setup Database Server

```bash
sudo apt update
sudo apt install mysql-server -y
```

* Secure MySQL:

```bash
sudo mysql_secure_installation
```

* Create DB and user:

```sql
CREATE DATABASE appdb;
CREATE USER 'appuser'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON appdb.* TO 'appuser'@'%';
FLUSH PRIVILEGES;
```

* Allow remote access:
  Edit:

```
/etc/mysql/mysql.conf.d/mysqld.cnf
```

Change:

```
bind-address = 0.0.0.0
```

Restart:

```bash
sudo systemctl restart mysql
```

---

### 4️⃣ Setup App Server (Spring Boot)

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
```

* Clone repo:

```bash
git clone <your-repo-url>
cd backend
```

* Configure DB connection:

```
spring.datasource.url=jdbc:mysql://<db-ip>:3306/appdb
spring.datasource.username=appuser
spring.datasource.password=password
```

* Run app:

```bash
./mvnw spring-boot:run
```

---

### 5️⃣ Setup Web Server (Frontend)

```bash
sudo apt update
sudo apt install nginx -y
```

* Deploy frontend build:

```bash
sudo rm -rf /var/www/html/*
sudo cp -r build/* /var/www/html/
```

* Configure Nginx reverse proxy:

```
location /api {
    proxy_pass http://<app-server-ip>:8080;
}
```

Restart:

```bash
sudo systemctl restart nginx
```

---

### 6️⃣ Test the Application

* Open browser:

```
http://<web-server-ip>
```

* Verify:

  * Frontend loads
  * API calls working
  * Data stored in DB

---

## 🔐 Security Notes

* Restrict MySQL access (only App Server IP)
* Use strong passwords
* Avoid exposing DB to public internet
* Use firewall rules properly

---

## 📌 Outcome

By the end of this phase, you will:

* Understand full system flow
* Know how services communicate
* Be ready to automate everything in next phases

---

## ➡️ Next Phase

👉 Phase 2: Shell Automation
We will automate all these steps using Bash scripts.
