#!/bin/bash
mkdir -p ~/.ssh
# echo "Host *
# ControlPath ~/.ssh/socket-%C
# ControlMaster auto
# ControlPersist 10m
# " > ~/.ssh/config
echo "$WPE_SSHG_KEY_PRIVATE" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
# chmod 600 ~/.ssh/config
ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa liamseprod@liamseprod.ssh.wpengine.net << EOF
cd ~/sites/liamseprod/
echo `date` && "$GHA_RUN_ID" >> action-scheduler-run.log 2>> action-scheduler-run-error.log
echo `date` && "$GHA_RUN_ID" >> cron-run.log 2>> cron-run-error.log
wp action-scheduler run >> action-scheduler-run.log 2>> action-scheduler-run-error.log
wp cron event run --due-now >> cron-run.log 2>> cron-run-error.log