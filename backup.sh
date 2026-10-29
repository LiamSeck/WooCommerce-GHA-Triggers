#!/bin/bash
curl -X POST "https://api.wpengineapi.com/v1/installs/a312874b-94ba-4d2b-90fd-c492881e429b/backups" \
  -u "WPE_API_USER_ID:WPE_API_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '{
  "description": "Backup via GitHub Action",
  "notification_emails": [
    "liam.seck@wpengine.com"
  ]
}'