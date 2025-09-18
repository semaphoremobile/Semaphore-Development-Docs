# Deployment

## SSH
Access to cloud VMs (e.g., Google Cloud) is via **SSH**—directly from the terminal or through a cloud service binary (ex. `gcloud`, `aws`, `az`). All deployment steps use this secure, encrypted connection.

## Capistrano
We deploy all source code to servers with [Capistrano](https://en.wikipedia.org/wiki/Capistrano), which:

- Automates releases to one or more servers
- Connects to servers securely over SSH
- Supports environment deployments (ex. staging, production)
- Supports DB migrations and rollbacks
- Supports custom Rake tasks
- Enables rollbacks to previous versions

### Common commands
```bash
cap staging deploy
cap production deploy
cap staging deploy:rollback
cap production deploy:rollback
cap staging deploy:migrations
cap production deploy:migrations
```

### Example Rake Task
```bash
desc "Clear the Laravel Cached Files"
task :clear_laravel_cache do
  on roles :all do 
    execute "cd #{deploy_to}/current && php artisan cache:clear"
  end
end
```