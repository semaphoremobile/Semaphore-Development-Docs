# lib/capistrano/tasks/docs.rake
namespace :docs do
  desc "Build MkDocs locally and rsync to the release path"
  task :build_upload do
    # 1) Build locally
    run_locally do
      info "Building MkDocs monorepo via scripts/build_all.sh…"
      execute :bash, "scripts/build_all.sh"
    end

    # 2) Upload via rsync to exactly the web host, sequentially
    on roles(fetch(:docs_roles, :web)), in: :sequence, wait: 1 do |host|
      # Ensure the release dirs exist (defensive)
      execute :mkdir, "-p", release_path
      %w[laravel react-native nodejs].each do |d|
        execute :mkdir, "-p", File.join(release_path, d)
      end

      # Build the SSH target like "ubuntu@34.68.120.176"
      target = "#{host.user || fetch(:user, ENV['USER'])}@#{host.hostname}"

      # 3) Use rsync from local → remote
      # Notes:
      # - trailing slashes mean: copy contents of source into dest dir
      # - --delete keeps remote in sync with local build
      run_locally do
        execute :rsync, "-az", "--delete",
                "_site/root/", "#{target}:#{release_path}/"
        execute :rsync, "-az", "--delete",
                "_site/laravel/", "#{target}:#{release_path}/laravel/"
        execute :rsync, "-az", "--delete",
                "_site/react-native/", "#{target}:#{release_path}/react-native/"
        execute :rsync, "-az", "--delete",
                "_site/nodejs/", "#{target}:#{release_path}/nodejs/"
      end

      # Permissions for static hosting
      execute :find, release_path, "-type d -exec chmod 755 {} \\;"
      execute :find, release_path, "-type f -exec chmod 644 {} \\;"

      info "Docs rsynced to #{release_path}."
    end
  end
end

after "deploy:updated", "docs:build_upload"