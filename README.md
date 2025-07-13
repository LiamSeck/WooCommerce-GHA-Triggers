# Workflow Status

[![Run-5-Minutes](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/cron-scheduler.yml/badge.svg)](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/cron-scheduler.yml)

[![CodeQL Advanced](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/codeql.yml/badge.svg)](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/codeql.yml)

[![Lint GHA Files](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/lint-check.yml/badge.svg)](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/lint-check.yml)

---

# WooCommerce-GHA-Triggers
Testing GitHub Actions to trigger the WooCommerce [Action Scheduler](https://actionscheduler.org/wp-cli/) and scheduled [WordPress Cron](https://developer.wordpress.org/cli/commands/cron/event/run/) events via [WP-CLI](https://wp-cli.org/) utilising the WP Engine [SSH Gateway](https://wpengine.com/support/ssh-gateway/).

---
# WordPress Cron Automation with GitHub Actions and WP Engine
#### Version 0.1 
#### Created by Liam Seck

This implementation allows you to run WordPress cron jobs reliably using GitHub Actions and WP Engine's SSH Gateway. The solution runs both `wp cron event run` and `wp action-scheduler run` commands every 5 minutes.

## Prerequisites

1. WP Engine hosting account
2. GitHub repository
3. SSH access to your WP Engine environment
4. WP-CLI installed on your WP Engine environment (comes pre-installed)

## Setup Instructions

1. Generate SSH Key
    ```bash
    ssh-keygen -t ed25519 -f ~/.ssh/wpengine_ed25519
    ```

2. Add Public Key to WP Engine
    * Go to https://my.wpengine.com/profile/ssh_keys
    * Click "New SSH Key"
    * Paste contents of `~/.ssh/wpengine_ed25519.pub`

3. Add Private Key to GitHub
    * Go to your GitHub repository settings
    * Navigate to Secrets and Variables > Actions
    * Create new secret named `WPE_SSHG_KEY_PRIVATE`
    * Paste contents of `~/.ssh/wpengine_ed25519`

4. Create GitHub Action Workflow
    * Create directory: `.github/workflows/`
    * Add file: `run-5-minutes.yml` with provided workflow content
    * Update `WPE_ENV` value to your WP Engine environment name

5. Add Script File
    * Create `script.sh` in repository root
    * Copy provided script content
    * Make executable: `chmod +x script.sh`

## Verification Steps

1. Test SSH Connection
    ```bash
    ssh {your-environment}@{your-environment}.ssh.wpengine.net
    ```

2. Manually Trigger Workflow
    * Go to Actions tab in GitHub repository
    * Select "Run-5-Minutes" workflow
    * Click "Run workflow"

3. Check Logs on WP Engine
    * Connect via SSH
    * View logs:
        ```bash
        cd sites/{your-environment}
        tail -f action-scheduler-run.log
        tail -f cron-run.log
        ```

## Monitoring

* GitHub Actions logs show execution status
* WP Engine logs track each run:
    * `action-scheduler-run.log` - Action Scheduler tasks
    * `action-scheduler-run-error.log` - Action Scheduler errors
    * `cron-run.log` - WordPress cron events
    * `cron-run-error.log` - WordPress cron errors

## Security Notes

* SSH key is stored securely in GitHub Secrets
* WP Engine SSH Gateway uses key-based authentication
* Script runs in isolated environment
* Logs are stored in site directory for accountability

## WP Engine Resources

[SSH Keys for Shell Access](https://wpengine.com/support/ssh-keys-for-shell-access/)

[SSH Gateway Guide](https://wpengine.com/support/ssh-gateway/)
