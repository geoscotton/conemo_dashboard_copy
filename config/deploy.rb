# config valid only for this version of Capistrano
lock "3.5.0"

set :application, "conemo_dashboard"
set :repo_url, "git@github.com:NU-CBITS/#{ fetch(:application) }.git"
set :rvm_type, :system
set :rvm_ruby_version, "2.3.0"

# Default branch is :master
ask :branch, proc { `git tag | gsort -V`.split("\n").last }

if fetch(:stage) == :staging
  set :deploy_to, "/var/www/apps/#{ fetch(:application) }"
elsif fetch(:stage) == :production
  set :deploy_to, "/var/www/html/src/#{ fetch(:application) }"
end

set :scm, :git
set :pty, true
set :linked_files, [
  "config/database.yml",
  "config/environments/#{ fetch(:stage) }.rb",
  "config/initializers/secret_token.rb",
  "config/initializers/devise_secret_token.rb"
]
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :keep_releases, 5

namespace :deploy_prepare do

  desc "Configure virtual host"
  task :create_vhost do
    on roles(:web), in: :sequence, wait: 5 do
      staging_vhost_config = <<-EOF
NameVirtualHost *:80
NameVirtualHost *:443

<VirtualHost *:80>
  ServerName conemo-staging.cbits.northwestern.edu
  Redirect permanent / https://conemo-staging.cbits.northwestern.edu/
</VirtualHost>

<VirtualHost *:443>
  PassengerFriendlyErrorPages off
  PassengerAppEnv staging
  PassengerRuby /usr/local/rvm/wrappers/ruby-#{ fetch(:rvm_ruby_version) }/ruby

  ServerName conemo-staging.cbits.northwestern.edu

  SSLEngine On
  SSLCertificateFile /etc/pki/tls/certs/cbits.northwestern.edu.crt
  SSLCertificateChainFile /etc/pki/tls/certs/cbits.northwestern.edu_intermediate.crt
  SSLCertificateKeyFile /etc/pki/tls/private/cbits.northwestern.edu.key

  DocumentRoot #{ fetch(:deploy_to) }/current/public
  RailsBaseURI /
  PassengerDebugLogFile /var/log/httpd/passenger.log

  <Directory #{ fetch(:deploy_to) }/current/public >
    Allow from all
    Options -MultiViews
  </Directory>
</VirtualHost>
      EOF

      production_vhost_config = <<-EOF
NameVirtualHost *:80
NameVirtualHost *:443

<VirtualHost *:80>
  ServerName conemo.northwestern.edu
  Redirect permanent / https://conemo.northwestern.edu/
</VirtualHost>

<VirtualHost *:443>
  PassengerFriendlyErrorPages off
  PassengerAppEnv production
  PassengerRuby /usr/local/rvm/wrappers/ruby-#{ fetch(:rvm_ruby_version) }/ruby
  # Always have at least 1 process in existence for the application
  PassengerMinInstances 1

  ServerName conemo.northwestern.edu

  SSLEngine On
  SSLCertificateFile /etc/pki/tls/certs/cbits-railsapps.nubic.northwestern.edu.crt
  SSLCertificateChainFile /etc/pki/tls/certs/komodo_intermediate_ca.crt
  SSLCertificateKeyFile /etc/pki/tls/private/cbits-railsapps.nubic.northwestern.edu.key

  DocumentRoot #{ fetch(:deploy_to) }/current/public
  RailsBaseURI /
  PassengerDebugLogFile /var/log/httpd/passenger.log

  <Directory #{ fetch(:deploy_to) }/current/public >
    Allow from all
    Options -MultiViews
  </Directory>

  AddOutputFilterByType DEFLATE text/html text/css application/javascript

  <Location /assets/>
    # RFC says only cache for 1 year
    ExpiresActive On
    ExpiresDefault "access plus 1 year"
  </Location>
</VirtualHost>

# Start the application before the first access
PassengerPreStart https://conemo.northwestern.edu:443/
      EOF

      vhost_config = { staging: staging_vhost_config, production: production_vhost_config }

      execute :echo, "\"#{ vhost_config[fetch(:stage)] }\"", ">", "/etc/httpd/conf.d/#{ fetch(:application) }.conf"
    end
  end

  desc "Configure Postgres"
  task :configure_pg do
    on roles(:web), in: :sequence, wait: 5 do
      execute :bundle, "config", "build.pg", "--with-pg-config=/usr/pgsql-9.3/bin/pg_config"
    end
  end

end

namespace :deploy do

  desc "Change deploy dir owner to apache"
  task :set_owner do
    on roles(:web), in: :sequence, wait: 5 do
      execute :sudo, :chgrp, "-R", "apache", fetch(:deploy_to)
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      execute :mkdir, "-p", release_path.join("tmp")
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, "cache:clear"
      # end
    end
  end

end

desc "copy ckeditor nondigest assets"
task :copy_nondigest_assets do
  on roles(:web), in: :sequence, wait: 5 do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, "ckeditor:create_nondigest_assets"
      end
    end
  end
end
after "deploy:assets:precompile", "copy_nondigest_assets"

#before "deploy:started", "deploy_prepare:create_vhost"
after "deploy_prepare:create_vhost", "deploy_prepare:configure_pg"
after "deploy_prepare:configure_pg", "deploy:set_owner"
after "bundler:install", "deploy:migrate"
after "deploy:finished", "deploy:restart"
after "deploy:updated", "deploy:cleanup"
