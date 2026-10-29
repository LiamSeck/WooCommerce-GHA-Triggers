#!/bin/bash
# mkdir -p ~/.ssh
# echo "${WPE_SSHG_KEY_PRIVATE}" > ~/.ssh/id_rsa
# chmod 600 ~/.ssh/id_rsa

# ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ${WPE_ENV}@${WPE_ENV}.ssh.wpengine.net <<EOF
# cd ~/sites/${WPE_ENV}/
curl -X POST "https://api.wpengineapi.com/v1/installs/a312874b-94ba-4d2b-90fd-c492881e429b/backups" \
  -u "${WPE_API_USER_ID}:${WPE_API_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d '{
  "description": "Backup via GitHub Action",
  "notification_emails": [
    "liam.seck@wpengine.com"
  ]
}'