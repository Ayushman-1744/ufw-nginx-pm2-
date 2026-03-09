                Internet
                    │
                    ▼
            Nginx Reverse Proxy
         (Rate limit 5 req/sec/IP)
                    │
         ┌──────────┴───────────┐
         │                      │
   Normal Requests         Excess Requests
         │                      │
         ▼                      ▼
 Node.js API (PM2)        HTTP 429 Response
 localhost:3000                │
                               ▼
                      Nginx access.log
                               │
                               ▼
                      defender.sh script
                               │
                               ▼
                          UFW Firewall
                               │
                               ▼
                        IP permanently banned
