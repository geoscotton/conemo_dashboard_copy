# frozen_string_literal: true
require "rails_helper"

module Tasks
  module AlertRules
    RSpec.describe NonAdherence do
      fixtures :all

      let(:participant) { Participant.active.where.not(nurse: nil).first }
      let(:now) { Time.zone.now }

      before do
        ContentAccessEvent.destroy_all
        SessionEvent.destroy_all
        Lesson.destroy_all
        Participant.where.not(id: participant.id).destroy_all
      end

      around do |ex|
        Time.use_zone(Participant::TIMEZONES[participant.locale]) { ex.run }
      end

      describe ".create_tasks" do
        context "when there have not been enough lessons released" do
          it "does not create a task" do
            expect do
              NonAdherence.create_tasks
            end.not_to change { Tasks::NonAdherenceCall.count }
          end
        end

        context "when there have been enough lessons released" do
          let!(:lessons) do
            (1..NonAdherence::THRESHOLD_LESSONS_MISSED + 1).map do |n|
              Lesson.create!(locale: participant.locale,
                             title: "t",
                             day_in_treatment: participant.study_day - n)
            end
          end
          let(:connectivity_alert) do
            Tasks::LackOfConnectivityCall.create!(participant: participant)
          end
          let(:adherence_alert) do
            Tasks::NonAdherenceCall.create!(participant: participant)
          end

          def access_lessons(count)
            (0...count).each do |i|
              SessionEvent.create!(participant: participant,
                                   lesson: lessons[i],
                                   occurred_at: now,
                                   event_type: SessionEvent::TYPES.access)
            end
          end

          context "and enough have been accessed" do
            it "does not create a task" do
              access_lessons 2

              expect do
                NonAdherence.create_tasks
              end.not_to change { Tasks::NonAdherenceCall.count }
            end

            context "and there was an existing adherence alert" do
              it "deletes it" do
                adherence_alert
                access_lessons 2

                expect do
                  NonAdherence.create_tasks
                end.to change { Tasks::NonAdherenceCall.deleted.count }.by(1)
              end
            end
          end

          context "and too many were missed" do
            context "and no connectivity alert is active" do
              context "and no sessions were released since the last alert " \
                      "was resolved" do
                it "doesn't create a task" do
                  adherence_alert.update(status: NurseTask::STATUSES.resolved)

                  expect do
                    NonAdherence.create_tasks
                  end.not_to change { Tasks::NonAdherenceCall.count }
                end
              end

              context "and a session was released since the last alert " \
                      "was resolved" do
                it "creates a task" do
                  adherence_alert.update(status: NurseTask::STATUSES.resolved,
                                         updated_at: 2.days.ago)

                  expect do
                    NonAdherence.create_tasks
                  end.to change { Tasks::NonAdherenceCall.count }.by(1)
                end
              end

              context "and the Participant does not have an associated Nurse" do
                it "does not create a task" do
                  participant.nurse.destroy
                  participant.reload

                  expect do
                    NonAdherence.create_tasks
                  end.not_to change { Tasks::NonAdherenceCall.count }
                end
              end
            end

            context "and a connectivity alert is active" do
              it "does not create a new adherence task" do
                connectivity_alert

                expect do
                  NonAdherence.create_tasks
                end.not_to change { Tasks::NonAdherenceCall.count }
              end

              it "does not delete an existing adherence task" do
                adherence_alert
                connectivity_alert

                expect do
                  NonAdherence.create_tasks
                end.not_to change { Tasks::NonAdherenceCall.deleted.count }
              end
            end
          end
        end
      end
    end
  end
end
