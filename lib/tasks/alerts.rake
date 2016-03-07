# frozen_string_literal: true
require "rubygems"

namespace :alerts do
  desc "triggers an alert for lack of connectivity"
  task connectivity: :environment do
    Tasks::AlertRules::LackOfConnectivity.create_tasks
  end

  desc "triggers an alert for lack of adherence"
  task adherence: :environment do
    Tasks::AlertRules::NonAdherence.create_tasks
  end
end
