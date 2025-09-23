# lib/capistrano/tasks/docs.rake
namespace :docs do
  desc "Build MkDocs locally and rsync to the release path"
  task :build_upload do
    # 1) Build locally (single unified site -> _site/)
    run_locally do
      info "Building MkDocs via scripts/build_all.sh…"
      execute :bash, "scripts/build_all.sh"
    end

    # 2) Upload via rsync to the web hosts, sequentially
    on roles(fetch(:docs_roles, :web)), in: :sequence, wait: 1 do |host|
      # Ensure the release dir exists
      execute :mkdir, "-p", release_path

      # Build the SSH target like "ubuntu@34.68.120.176"
      target_user = host.user || fetch(:user, ENV['USER'])
      target = "#{target_user}@#{host.hostname}"

      # 3) Rsync the entire built site to the release root
      #    Trailing slashes:
      #      - on the source means "copy CONTENTS of _site/"
      #      - on the dest ensures rsync places files inside release_path/
      run_locally do
        execute :rsync, "-az", "--delete",
                "_site/", "#{target}:#{release_path}/"
      end

      # 4) Permissions for static hosting
      execute :find, release_path, "-type d -exec chmod 755 {} \\;"
      execute :find, release_path, "-type f -exec chmod 644 {} \\;"

      info "Docs rsynced to #{release_path}."
    end
  end
end

# Hook this after your app deploy finishes updating the release
after "deploy:updated", "docs:build_upload"