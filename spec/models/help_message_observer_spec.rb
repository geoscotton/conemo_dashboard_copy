# frozen_string_literal: true
require "rails_helper"

RSpec.describe HelpMessageObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { HelpMessageObserver.instance }
  let(:help_message) do
    instance_double(HelpMessage,
                    participant: participant,
                    sent_at: Time.zone.now)
  end

  context "when a Help Message is created" do
    context "and the Participant is not associated with a Nurse" do
      it "does not create a Help Request Task" do
        NurseTask.destroy_all
        participant.nurse.destroy
        participant.reload

        expect do
          observer.after_create(help_message)
        end.not_to change {
          Tasks::HelpRequest
            .for_participant(participant).count
        }
      end
    end

    context "and there are no Help Request Tasks" do
      it "creates a Help Request Task" do
        NurseTask.destroy_all

        expect do
          observer.after_create(help_message)
        end.to change {
          Tasks::HelpRequest
            .for_participant(participant).count
        }.by(1)
      end
    end

    context "and there is an active Help Request Task" do
      it "does not create a Help Request Task" do
        NurseTask.destroy_all
        Tasks::HelpRequest.create!(
          participant: participant,
          scheduled_at: Time.zone.now
        )

        expect do
          observer.after_create(help_message)
        end.not_to change {
          Tasks::HelpRequest
            .for_participant(participant).count
        }
      end
    end

    context "and there is an active Help Request Task" do
      it "creates a Help Request Task" do
        NurseTask.destroy_all
        Tasks::HelpRequest.create!(
          participant: participant,
          scheduled_at: Time.zone.now,
          status: NurseTask::STATUSES.resolved
        )

        expect do
          observer.after_create(help_message)
        end.to change {
          Tasks::HelpRequest
            .for_participant(participant).count
        }.by(1)
      end
    end
  end
end
