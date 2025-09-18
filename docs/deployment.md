# Deployment

## SSH
Access to cloud VMs (e.g., Google Cloud) is via **SSH**—either your terminal or `gcloud` CLI. All deployment steps use this secure, encrypted connection.

## Capistrano
We deploy with [Capistrano](https://en.wikipedia.org/wiki/Capistrano), which:
- Automates releases to one or more servers
- Supports DB migrations and rollbacks
- Enables rollbacks to previous versions

**Common commands:**
```bash
cap staging deploy
cap production deploy
cap staging deploy:rollback
cap production deploy:rollback
cap staging deploy:migrations
cap production deploy:migrations
```