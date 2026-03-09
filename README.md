                                 #      **Secure Gateway Architecture **

This project demonstrates a **secure API gateway architecture** built on a Linux server using **Nginx reverse proxy, Node.js backend, firewall hardening, rate limiting, and automated active defense**.

The system is designed to simulate a **production-style DevOps security pipeline** where malicious traffic is automatically detected and blocked at the firewall level.

---

# 🏗 Architecture Overview

```
Internet
   │
   ▼
Nginx Reverse Proxy
(Rate Limit: 1 req/sec/IP)
   │
   ├── Normal Requests → Node.js API (PM2)
   │                     localhost:3000
   │
   └── Excess Requests → HTTP 429 Response
                         │
                         ▼
                   Nginx access.log
                         │
                         ▼
                   defender.sh
                   (Log Scanner)
                         │
                         ▼
                    UFW Firewall
                         │
                         ▼
                Malicious IP Blocked
```

---

# Project Goals 

This setup demonstrates how to:

* Secure a Linux server with firewall policies
* Deploy an API behind a reverse proxy
* Implement rate limiting
* Automatically detect malicious traffic
* Dynamically block abusive IP addresses

---

# ⚙️ Tech Stack

| Component      | Purpose                       |
| -------------- | ----------------------------- |
| Linux (Ubuntu) | Server environment            |
| Nginx          | Reverse proxy + rate limiting |
| Node.js        | Backend API controller        |
| Express.js     | API framework                 |
| PM2            | Node process manager          |
| UFW            | Firewall for IP blocking      |
| Bash           | Automated defense script      |
| Cron           | Scheduled task automation     |

---

# Phase 1 – Server Security Setup 🔐

### Firewall Configuration

Using **UFW (Uncomplicated Firewall)**.

Default policy:

```
deny incoming
allow outgoing
```

### Open Required Ports

| Port            | Purpose             |
| --------------- | ------------------- |
| 2223            | Custom SSH          |
| 80              | HTTP                |
| 443             | HTTPS               |
| 10000–20000 UDP | Real-time streaming |

Example:

```
sudo ufw allow 2223/tcp
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 10000:20000/udp
```

### Block Direct API Access

```
sudo ufw deny 3000
```

This ensures the backend **cannot be accessed directly from the internet**.

---

# Phase 2 – Nginx Reverse Proxy 🌐

Install Nginx:

```
sudo apt install nginx -y
```

Nginx forwards traffic to the backend API.

Example configuration:

```
server {
    listen 80;

    location / {
        proxy_pass http://127.0.0.1:3000;
    }
}
```

---

# 🚧 Rate Limiting (Anti-DDoS)



If exceeded:

```
429 Too Many Requests
```

---

# Phase 3 – Backend Controller 🧠

Install Node.js:

```
sudo apt install nodejs npm
```

Install Express:

```
npm install express
```

### Minimal API Server


```

API Endpoint:

```
GET /api/status
```

Response:

```
{
 "status": "secure",
 "message": "Maachao Gateway Active"
}
```

---

# Running Node App with PM2

Install PM2:

```
npm install -g pm2
```

Start application:

```
pm2 start server.js --name gateway-api
```

Enable startup:

```
pm2 startup
pm2 save
```

Now the API **automatically restarts after server reboot**.

---

# Phase 4 – Active Defense Script 🛡

Even though Nginx rate limiting protects the API, it still consumes resources.

To improve security, a **Bash script monitors Nginx logs and bans abusive IPs automatically**.

---

# defender.sh Script

Location:

```
/usr/local/bin/defender.sh
```

Script logic:

1. Scan `access.log`
2. Detect IPs triggering **429 errors**
3. Count occurrences
4. If more than **3 times**
5. Block IP using firewall

---

# Automation with Cron ⏱

Run the script every minute.

```
sudo crontab -e
```

Add:

```
* * * * * /usr/local/bin/defender.sh
```

This ensures **continuous monitoring of attack attempts**.

---

# 🔐 Security Layers Implemented

| Layer                 | Protection                   |
| --------------------- | ---------------------------- |
| Firewall              | Blocks unauthorized ports    |
| Reverse Proxy         | Hides backend services       |
| Rate Limiting         | Prevents request flooding    |
| Log Monitoring        | Detects malicious activity   |
| Active Defense Script | Automatically bans attackers |

---

# Final Flow of Project

User Request
     │
     ▼
Nginx Reverse Proxy
     │
     ├─ Valid traffic → Node.js API
     │
     └─ Abusive traffic → 429 error
                           │
                           ▼
                     Logged in Nginx
                           │
                           ▼
                     defender.sh
                           │
                           ▼
                     UFW Firewall
                           │
                           ▼
                  Attacker IP banned
```

---

# Future Improvements

Potential production enhancements:

* HTTPS with Let's Encrypt
* Fail2Ban integration
* Docker containerization
* Kubernetes deployment
* Centralized logging (ELK stack)
* Cloudflare DDoS protection
* Prometheus monitoring

---

# Key DevOps Concepts Demonstrated

* Reverse Proxy Architecture
* API Gateway Pattern
* Rate Limiting
* Linux Firewall Hardening
* Log Analysis Automation
* Infrastructure Security
* Process Management with PM2

---
