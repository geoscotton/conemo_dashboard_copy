set :output, "#{path}/log/cron.log"

every 1.hours do
  # command "cd /var/www/html/src/rogalski/current && RAILS_ENV=production rvm ruby-2.0.0-p353 exec bundle exec rake webex:notify --silent"
end