# 💣 Incident Playbook (Phase 1)

> Fast, real-world failures + how to fix them.
> Think → **Detect → Diagnose → Fix → Prevent**

---

## ⚡ Debug Rule (Always Follow)

**Service → Port → Network → Config → Logs**

---

## 🔴 DB Down

**Break**

```bash
sudo systemctl stop mysql
```

**Detect**
App crash / DB connection error

**Fix**

```bash
sudo systemctl start mysql
```

**Prevent**
Enable auto-start + monitoring

---

## 🔴 Wrong DB Credentials

**Break**
Change DB password in app

**Detect**
`Access denied for user`

**Fix**

```sql
ALTER USER 'appuser'@'%' IDENTIFIED BY 'password';
```

**Prevent**
Use env vars / secret management

---

## 🔴 Network Block (3306)

**Break**
Close DB port

**Detect**
Timeout / no response

**Fix**

```bash
nc -zv <db-ip> 3306
```

(open firewall)

**Prevent**
Allow only app server IP

---

## 🔴 Nginx 502

**Break**

```nginx
proxy_pass http://wrong-ip:8080;
```

**Detect**
502 Bad Gateway

**Fix**

```bash
sudo systemctl restart nginx
```

**Prevent**
Avoid hardcoded IPs

---

## 🔴 App Crash

**Break**

```bash
kill -9 <pid>
```

**Detect**
API down

**Fix**

```bash
./mvnw spring-boot:run
```

**Prevent**
Use systemd / Docker

---

## 🔴 Port Conflict

**Break**
Run another app on 8080

**Detect**
`Port already in use`

**Fix**

```bash
lsof -i :8080
kill -9 <pid>
```

**Prevent**
Standardize ports

---

## 🔴 Wrong IP

**Break**
Wrong backend IP

**Detect**
Frontend loads, API fails

**Fix**

```bash
curl http://<app-ip>:8080
```

**Prevent**
Use DNS

---

## 🔴 Permission Denied

**Break**

```bash
chmod -x mvnw
```

**Detect**
Permission denied

**Fix**

```bash
chmod +x mvnw
```

**Prevent**
Check file permissions

---

## 🔴 Disk Full ⚠️

**Break**
Fill disk

**Detect**
Random failures

**Fix**

```bash
df -h
```

**Prevent**
Log rotation + monitoring

---

## 🔴 Bad Config

**Break**
Wrong env values

**Detect**
App behaves weird

**Fix**

```bash
printenv | grep DB
```

**Prevent**
Validate configs before deploy

---

## 🏁 Outcome

You now know how to:

* Break systems safely
* Debug like a DevOps engineer
* Fix issues fast under pressure

---

