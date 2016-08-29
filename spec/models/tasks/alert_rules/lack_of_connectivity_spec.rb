# frozen_string_literal: true
require "rails_helper"

module Tasks
  module AlertRules
    RSpec.describe LackOfConnectivity do
      fixtures :all

      let(:participant) { Participant.active.where.not(nurse: nil).first }
      let(:inactive_participant) do
        Participant.where.not(status: Participant::ACTIVE).first
      end
      let(:connectivity_alert) do
        Tasks::LackOfConnectivityCall.create!(participant: participant)
      end

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
            device = instance_double(Device,
                                     last_seen_at: Time.zone.now - 1.day,
                                     participant: participant)

            expect do
              LackOfConnectivity.create_tasks([device])
            end.not_to change { Tasks::LackOfConnectivityCall.count }
          end

          context "and there was an existing connectivity alert" do
            it "deletes it" do
              connectivity_alert
              device = instance_double(Device,
                                       last_seen_at: Time.zone.now - 14.minutes,
                                       participant: participant)

              expect do
                LackOfConnectivity.create_tasks([device])
              end.to change { Tasks::LackOfConnectivityCall.deleted.count }.by(1)
            end
          end
        end

        context "when a device has not been connected recently" do
          let(:stale_device) do
            long_ago = Time.zone.now -
                       (LackOfConnectivity::ALERTABLE_AFTER_DAYS + 1).days

            instance_double(Device,
                            last_seen_at: long_ago,
                            participant: participant)
          end
          let(:stale_inactive_device) do
            long_ago = Time.zone.now -
                       (LackOfConnectivity::ALERTABLE_AFTER_DAYS + 1).days

            instance_double(Device,
                            last_seen_at: long_ago,
                            participant: inactive_participant)
          end

          context "and there are no tasks" do
            it "creates a task" do
              expect do
                LackOfConnectivity.create_tasks([stale_device])
              end.to change { Tasks::LackOfConnectivityCall.count }.by(1)
            end

            context "and the participant is no longer active" do
              it "does not create a task" do
                expect do
                  LackOfConnectivity.create_tasks([stale_inactive_device])
                end.not_to change { Tasks::LackOfConnectivityCall.count }
              end
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
            let(:resolved_task) do
              Tasks::LackOfConnectivityCall.create!(
                participant: participant,
                status: NurseTask::STATUSES.resolved
              )
            end

            context "and the task was resolved recently" do
              it "doesn't create a task" do
                resolved_task.update updated_at: 5.minutes.ago

                expect do
                  LackOfConnectivity.create_tasks([stale_device])
                end.not_to change { Tasks::LackOfConnectivityCall.count }
              end
            end

            context "and the task was resolved long ago" do
              it "creates a task" do
                resolved_task.update updated_at: 3.days.ago

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
end
