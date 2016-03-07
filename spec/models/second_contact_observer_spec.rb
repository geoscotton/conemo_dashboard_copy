# frozen_string_literal: true
require "rails_helper"

RSpec.describe SecondContactObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { SecondContactObserver.instance }
  let(:second_contact) do
    instance_double(SecondContact,
                    participant: participant,
                    next_contact: Time.zone.now)
  end

  it "resolves the Follow up Call Week One Task" do
    Tasks::FollowUpCallWeekOne.create!(
      nurse: participant.nurse,
      participant: participant
    )

    expect do
      observer.after_create(second_contact)
    end.to change {
      Tasks::FollowUpCallWeekOne
        .for_nurse_and_participant(participant.nurse, participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
