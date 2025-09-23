# Continuous Integration

## CircleCI
Continuous integration (CI) is a DevOps software development practice where developers regularly merge their code changes into a central repository (Github), after which automated builds and tests are run. [CircleCi](https://circleci.com) is used for all our staging builds.

**Example CircleCI Config File:**
```yml
# Capistrano CircleCI config
version: 2.1

jobs:
  build:
    docker:
      - image: cimg/ruby:3.2.2-browsers
    working_directory: ~/repo

    steps:
      - run:
          name: Add github.com to known_hosts
          command: mkdir -p ~/.ssh && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

      - checkout

      - restore_cache:
          keys:
            - v1-dependencies-{{ checksum "Gemfile.lock" }}

      - run:
          name: Install Ruby deps
          command: |
            set -euo pipefail
            gem update --system
            gem install bundler
            bundle install --retry=3 --path vendor/bundle

      - save_cache:
          key: v1-dependencies-{{ checksum "Gemfile.lock" }}
          paths:
            - ./vendor/bundle

      # Set environment based on branch name and parse variables
      - run:
          name: Set deployment environment
          command: |
            set -euo pipefail
            echo "CIRCLE_BRANCH=${CIRCLE_BRANCH}"

            if [[ "${CIRCLE_BRANCH}" == "staging" ]]; then
              DEPLOY_ENV="staging"
              DEPLOY_TO="${DEPLOY_TO%|*}"
              echo "Deploying to staging"
            else
              echo "Branch does not match deployment criteria. Skipping."
              exit 0
            fi

            # Persist for subsequent steps
            echo "export DEPLOY_ENV=${DEPLOY_ENV}" >> "$BASH_ENV"
            echo "export DEPLOY_TO=${DEPLOY_TO}" >> "$BASH_ENV"
            echo "export MY_DEPLOY_BRANCH=${MY_DEPLOY_BRANCH:-}" >> "$BASH_ENV"
          when: always

      - run:
          name: Capistrano deploy
          command: |
            if [[ -n "${DEPLOY_ENV:-}" ]]; then
              bundle exec cap "${DEPLOY_ENV}" deploy
            fi

      - run:
          name: Capistrano migrations
          command: |
            if [[ -n "${DEPLOY_ENV:-}" ]]; then
              bundle exec cap "${DEPLOY_ENV}" laravel:migrate
            fi

      - run:
          name: Clear Laravel cache
          command: |
            if [[ -n "${DEPLOY_ENV:-}" ]]; then
              bundle exec cap "${DEPLOY_ENV}" clear_laravel_cache
            fi

      - run:
          name: PHP-FPM restart
          command: |
            if [[ -n "${DEPLOY_ENV:-}" ]]; then
              bundle exec cap "${DEPLOY_ENV}" php_fpm_restart
            fi

      - run:
          name: Composer update
          command: |
            if [[ -n "${DEPLOY_ENV:-}" ]]; then
              bundle exec cap "${DEPLOY_ENV}" composer_update
            fi

      - run:
          name: Composer dump-autoload
          command: |
            if [[ -n "${DEPLOY_ENV:-}" ]]; then
              bundle exec cap "${DEPLOY_ENV}" composer_dump_autoload
            fi

workflows:
  version: 2
  build_and_deploy:
    jobs:
      - build:
          filters:
            branches:
              only:
                - staging

```