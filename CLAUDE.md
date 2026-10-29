# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Does

Triggers WordPress cron events and WooCommerce Action Scheduler tasks on a schedule via GitHub Actions and WP Engine's SSH Gateway. Two scripts run on separate schedules:

- `script.sh` — SSHes into the WP Engine environment every 5 minutes and runs `wp action-scheduler run` and `wp cron event run --due-now`, logging output to files on the server.
- `backup.sh` — Calls the WP Engine API to trigger a site backup every 4 hours.

## Linting (runs in CI on push/PR)

```bash
# Shell scripts
find . -name "*.sh" -type f | xargs -I {} shellcheck --severity=error {}

# YAML files
find . -name "*.yml" -type f | xargs -I {} yamllint {}
```

## GitHub Actions Workflows

| File | Trigger | Purpose |
|------|---------|---------|
| `cron-scheduler.yml` | Every 5 min + manual | Runs `script.sh` via SSH |
| `backup-scheduler.yml` | Every 4 hours + manual | Runs `backup.sh` via WP Engine API |
| `lint-check.yml` | Push/PR to main | Shellcheck + yamllint |
| `codeql.yml` | Push/PR to main + weekly | Security scanning |

## Required GitHub Secrets

All workflows use the `Production` environment. Secrets must be set there:

- `WPE_SSHG_KEY_PRIVATE` — Ed25519 private key added to WP Engine SSH Keys
- `WPE_API_USER_ID` — WP Engine API user ID
- `WPE_API_PASSWORD` — WP Engine API password

## Key Config Values

- `WPE_ENV: liamseprod` — hardcoded in both workflow files; update this when targeting a different WP Engine environment.
- The `action-scheduler-disable-default-runner` plugin must be active on the WordPress site to prevent double-execution when running Action Scheduler via WP-CLI.

## Log Files on Server

Logs are written to `~/sites/{WPE_ENV}/` on the WP Engine server:
- `action-scheduler-run.log` / `action-scheduler-run-error.log`
- `cron-run.log` / `cron-run-error.log`
