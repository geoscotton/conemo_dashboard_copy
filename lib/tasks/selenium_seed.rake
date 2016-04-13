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

namespace :selenium_seed do
  desc "seed the database with fixtures from spec/selenium_fixtures"
  task with_fixtures: :environment do
    path = File.join(File.dirname(__FILE__), "..", "..", "spec", "selenium_fixtures")
    ActiveRecord::FixtureSet.create_fixtures path, [
      :users, :participants, :"bit_core/slideshows", :"bit_core/slides", :lessons,
      :patient_contacts, :first_contacts, :first_appointments, :second_contacts,
      :third_contacts, :final_appointments, :content_access_events,
      :session_events, :responses, :help_messages, :logins, :nurse_tasks,
      :supervisor_notifications, :"token_auth/configuration_tokens",
      :call_to_schedule_final_appointments, :help_request_calls,
      :lack_of_connectivity_calls, :non_adherence_calls, :participant_start_dates,
      :planned_activities, :supervision_sessions, :smartphones
    ]
  end
end
