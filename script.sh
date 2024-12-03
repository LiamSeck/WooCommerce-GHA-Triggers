#!/bin/bash
mkdir -p ~/.ssh
echo "Host *
ControlPath ~/.ssh/socket-%C
ControlMaster auto
ControlPersist 10m
" ~/.ssh/config
echo "$WPE_SSHG_KEY_PRIVATE" | tr -d '\r' > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o StrictHostKeyChecking=no -tt liamseprod@liamseprod.ssh.wpengine.net
cd ~/sites/liamseprod/
wp action-scheduler run >> action-scheduler-run.log 2>> action-scheduler-run-error.log