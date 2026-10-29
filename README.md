# Workflow Status

[![Run-5-Minutes](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/cron-scheduler.yml/badge.svg)](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/cron-scheduler.yml) [![Run-Hourly-Backup](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/backup-scheduler.yml/badge.svg)](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/backup-scheduler.yml) [![CodeQL Advanced](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/codeql.yml/badge.svg)](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/codeql.yml) [![Lint GHA Files](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/lint-check.yml/badge.svg)](https://github.com/LiamSeck/WooCommerce-GHA-Triggers/actions/workflows/lint-check.yml)

---

# WooCommerce-GHA-Triggers

Testing GitHub Actions to trigger the WooCommerce [Action Scheduler](https://actionscheduler.org/wp-cli/) and scheduled [WordPress Cron](https://developer.wordpress.org/cli/commands/cron/event/run/) events via [WP-CLI](https://wp-cli.org/) utilising the WP Engine [SSH Gateway](https://wpengine.com/support/ssh-gateway/).

The [action-scheduler-disable-default-runner plugin](https://github.com/woocommerce/action-scheduler-disable-default-runner) should be installed and enabled when running Action Scheduler via WP CLI. This disables the Action Scheduler's default queue runner, by removing it from the `action_scheduler_run_queue` hook.

---
# WordPress Cron Automation with GitHub Actions and WP Engine
#### Version 0.1
#### Created by Liam Seck

This implementation allows you to run WordPress cron jobs reliably using GitHub Actions and WP Engine's SSH Gateway. It also triggers scheduled site backups via the WP Engine API.

## Workflows

| Workflow | Schedule | Description |
|----------|----------|-------------|
| `cron-scheduler.yml` | Every 5 minutes | SSH into WP Engine and run `wp action-scheduler run` + `wp cron event run --due-now` |
| `backup-scheduler.yml` | Every 4 hours | Trigger a site backup via the WP Engine API |
| `lint-check.yml` | Push / PR to main | Shellcheck + yamllint validation |
| `codeql.yml` | Push / PR to main + weekly | Security scanning |

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

3. Add Secrets to GitHub
    * Go to your repository Settings > Secrets and Variables > Actions
    * Under the **Production** environment, add the following secrets:

    | Secret | Description |
    |--------|-------------|
    | `WPE_SSHG_KEY_PRIVATE` | Contents of `~/.ssh/wpengine_ed25519` |
    | `WPE_API_USER_ID` | WP Engine API user ID |
    | `WPE_API_PASSWORD` | WP Engine API password |

4. Update Environment Name
    * In both `cron-scheduler.yml` and `backup-scheduler.yml`, update `WPE_ENV` to your WP Engine environment name.

5. Make Scripts Executable
    ```bash
    chmod +x script.sh backup.sh
    ```

## Verification Steps

1. Test SSH Connection
    ```bash
    ssh {your-environment}@{your-environment}.ssh.wpengine.net
    ```

2. Manually Trigger a Workflow
    * Go to the Actions tab in your GitHub repository
    * Select a workflow (e.g. "Run-5-Minutes")
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

* GitHub Actions logs show execution status per run
* WP Engine logs track each run in `~/sites/{WPE_ENV}/`:
    * `action-scheduler-run.log` — Action Scheduler tasks
    * `action-scheduler-run-error.log` — Action Scheduler errors
    * `cron-run.log` — WordPress cron events
    * `cron-run-error.log` — WordPress cron errors

## WP Engine Resources

[SSH Keys for Shell Access](https://wpengine.com/support/ssh-keys-for-shell-access/)

[SSH Gateway Guide](https://wpengine.com/support/ssh-gateway/)

[WP Engine API Reference](https://wpengineapi.com/)
