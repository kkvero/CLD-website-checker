#!/bin/bash
# Boiler plate 
# - to check the health of a website using 'curl'
# - send me the health status via Telegram bot 

URL="https://mywebsite.com"
TG_BOT_TOKEN="YOUR_TELEGRAM_BOT_TOKEN"
TG_CHAT_ID="YOUR_TELEGRAM_CHAT_ID"

# Check if the laptop is NOT connected to the internet 
# -c 1: send 1 packet, -W 1: wait max 1 second 
if ! ping -c 1 -W 1 1.1.1.1 > /dev/null 2>&1; then 
	exit 0 # Exit silently; no internet connection 
fi

STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$STATUS_CODE" -eq 200 ]; then
    # --- UNCOMMENT THE LINE BELOW TO RECEIVE "OK" NOTIFICATIONS ---
    curl -s -X POST "https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage" -d "chat_id=$TG_CHAT_ID" -d "text=✅ $URL is online (HTTP 200)" > /dev/null
    : # The colon is a bash placeholder that does nothing when the line above is commented out
else
    # Alert only on non-200 codes
    MESSAGE="🚨 ALERT: $URL returned status code $STATUS_CODE"
    curl -s -X POST "https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage" -d "chat_id=$TG_CHAT_ID" -d "text=$MESSAGE" > /dev/null
fi

exit 0