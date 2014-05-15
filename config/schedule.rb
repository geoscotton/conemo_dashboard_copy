set :output, "#{path}/log/cron.log"

every 5.minutes do
  rake "sms:message"
  rake "prw_import:sync"
end