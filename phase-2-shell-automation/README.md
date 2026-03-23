# 📘 Phase 2: Shell Automation (3-Tier DevSecOps Project)

## 🎯 Goal

In this phase, we convert all manual steps from Phase 1 into **automated shell scripts**.

> Instead of setting up everything step-by-step, we will automate the entire infrastructure and application setup.

We will:

* Automate server configuration
* Automate dependency installation
* Automate application deployment
* Ensure repeatable and consistent setup

---

## 🏗️ Architecture Overview

Same 3-tier architecture, but now **automated**:

```
User → Web Server → App Server → Database Server
```

### 🔄 Key Difference from Phase 1

| Phase   | Approach                |
| ------- | ----------------------- |
| Phase 1 | Manual setup            |
| Phase 2 | Script-based automation |

---

## 🧠 Concept: Why Automation?

Manual setup is:

❌ Error-prone
❌ Time-consuming
❌ Not scalable

Automation gives:

✅ Consistency
✅ Speed
✅ Reusability
✅ Real DevOps experience

---

## 📂 Script Structure

All automation scripts are organized as:

```
scripts/
│
├── setup.sh        # Main entry point
├── web.sh          # Web server setup (Nginx + React)
├── app.sh          # App server setup (Spring Boot)
├── db.sh           # Database setup (MySQL)
```

---

## ⚙️ What Gets Automated

### 🗄️ Database Layer

* Install MySQL
* Secure installation
* Create database and user
* Enable remote access
* Restart MySQL service

---

### ⚙️ App Layer

* Install Java (OpenJDK 17)
* Clone backend repository
* Configure database connection
* Build and run Spring Boot app

---

### 🌐 Web Layer

* Install Nginx
* Install Node.js & npm
* Clone frontend repository
* Build React application
* Deploy build files to Nginx

---

## 🚀 How to Run

### 1️⃣ Clone Repository

```bash
git clone <your-repo-url>
cd 3tier-devsecops-ai
```

---

### 2️⃣ Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

---

### 3️⃣ Run Setup Script

```bash
./scripts/setup.sh
```

> 🎯 This single command will configure all 3 layers automatically

---

## 🔄 How It Works

`setup.sh` acts as the **controller script**:

```bash
#!/bin/bash

echo "Starting 3-Tier Setup..."

bash db.sh
bash app.sh
bash web.sh

echo "Setup Completed!"
```

Each script:

* Handles one layer
* Runs independently
* Can be reused or debugged separately

---

## 📌 Expected Outcome

After execution:

* MySQL is installed and configured ✅
* Backend is running on port 8080 ✅
* Nginx is serving React app ✅
* Full application is live ✅

---

## 🔐 Security Notes

Even in automation:

* Do not hardcode sensitive credentials (use env variables later)
* Restrict DB access to App Server only
* Validate inputs in scripts
* Use least privilege principle

---

## 💣 Troubleshooting

If something fails:

* Check logs:

  ```bash
  systemctl status mysql
  systemctl status nginx
  ```

* Run scripts individually:

  ```bash
  bash scripts/db.sh
  ```

* Verify ports:

  ```bash
  netstat -tulnp
  ```

---

## 🧪 Learning Outcome

By completing this phase, you will:

* Understand real-world deployment automation
* Learn modular shell scripting
* Build reusable DevOps workflows
* Prepare for CI/CD pipelines

---

## ➡️ Next Phase

👉 Phase 3: CI/CD Pipeline

We will:

* Automate build & deployment pipelines
* Integrate GitHub Actions / Jenkins
* Move towards continuous delivery

---

## 📢 Final Thought

> “Manual work teaches you the system.
> Automation makes you a DevOps engineer.”

