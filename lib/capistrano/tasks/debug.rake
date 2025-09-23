namespace :debug do
  task :hosts do
    on roles(:all) do |h|
      info "HOST=#{h.hostname} ROLES=#{h.roles.to_a.join(',')}"
    end
  end
end