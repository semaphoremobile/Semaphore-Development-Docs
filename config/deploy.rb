# config/deploy.rb
set :application, "docs.semaphoremobile.com"
set :deploy_to, "/var/www/html/docs.semaphoremobile.com"
set :repo_url, "git@githubmk:semaphoremobile/Semaphore-Development-Docs.git"
set :branch, "main"
set :keep_releases, 5


