# frozen_string_literal: true
require "rails_helper"

module Tasks
  module AlertRules
    RSpec.describe LackOfConnectivity do
      fixtures :all

      let(:participant) { Participant.where.not(nurse: nil).first }

      describe ".create_tasks" do
        context "when there are no devices" do
          it "does not create a task" do
            expect do
              LackOfConnectivity.create_tasks([])
            end.not_to change { Tasks::LackOfConnectivityCall.count }
          end
        end

        context "when a device has been recently connected" do
          it "does not create a task" do
            device = double("Device", last_seen_at: Time.zone.now - 1.day)

            expect do
              LackOfConnectivity.create_tasks([device])
            end.not_to change { Tasks::LackOfConnectivityCall.count }
          end
        end

        context "when a device has not been connected recently" do
          let(:stale_device) do
            long_ago = Time.zone.now -
                       (LackOfConnectivity::ALERTABLE_AFTER_DAYS + 1).days

            double("Device",
                   last_seen_at: long_ago,
                   participant: participant)
          end

          context "and there are no tasks" do
            it "creates a task" do
              expect do
                LackOfConnectivity.create_tasks([stale_device])
              end.to change { Tasks::LackOfConnectivityCall.count }.by(1)
            end
          end

          context "and there is an active task" do
            it "does not create a task" do
              Tasks::LackOfConnectivityCall.create!(
                participant: participant
              )

              expect do
                LackOfConnectivity.create_tasks([stale_device])
              end.not_to change { Tasks::LackOfConnectivityCall.count }
            end
          end

          context "and there is a resolved task" do
            it "creates a task" do
              Tasks::LackOfConnectivityCall.create!(
                participant: participant,
                status: NurseTask::STATUSES.resolved
              )

              expect do
                LackOfConnectivity.create_tasks([stale_device])
              end.to change { Tasks::LackOfConnectivityCall.count }.by(1)
            end
          end
        end
      end
    end
  end
end
