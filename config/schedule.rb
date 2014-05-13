set :output, "#{path}/log/cron.log"

every 5.minutes do
  rake "sms:message"
end