# frozen_string_literal: true
require "active_record/fixtures"

module ActiveRecord
  module ConnectionAdapters
    # Override referential integrity config to allow fixture loading.
    class PostgreSQLAdapter < AbstractAdapter
      # PostgreSQL only disables referential integrity when connection
      # user is root and that is not the case.
      def disable_referential_integrity
        yield
      end
    end
  end
end

namespace :seed do
  desc "seed the database with fixtures from spec/fixtures"
  task with_fixtures: :environment do
    path = File.join(File.dirname(__FILE__), "..", "..", "spec", "fixtures")
    ActiveRecord::FixtureSet.create_fixtures path, [
      :users, :participants, :"bit_core/slideshows", :"bit_core/slides", :lessons,
      :first_contacts, :content_access_events,
      :responses, :first_appointments, :patient_contacts,
      :responses, :smartphones, :help_messages,
      :second_contacts, :third_contacts, :participant_start_dates
    ]
  end
end
