require "rubygems"

namespace :alerts do
  desc "triggers an alert for lack of connectivity"
  task connectivity: :environment do
    Tasks::AlertRules::LackOfConnectivity.create_tasks
  end
end
