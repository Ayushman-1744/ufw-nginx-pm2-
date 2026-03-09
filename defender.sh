#!/bin/bash

LOG_FILE="/var/log/nginx/access.log"
THRESHOLD=3

# Find IPs with 429 responses
ips=$(grep ' 429 ' $LOG_FILE | awk '{print $1}' | sort | uniq -c)

echo "$ips" | while read count ip
do
    if [ "$count" -gt "$THRESHOLD" ]; then

        # Check if already blocked
        sudo ufw status | grep -q "$ip"

        if [ $? -ne 0 ]; then
            echo "Blocking malicious IP: $ip"
            sudo ufw deny from $ip
        fi

    fi
done
