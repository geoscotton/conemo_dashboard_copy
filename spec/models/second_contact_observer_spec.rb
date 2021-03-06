# frozen_string_literal: true
require "rails_helper"

RSpec.describe SecondContactObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { SecondContactObserver.instance }
  let(:second_contact) do
    instance_double(SecondContact, participant: participant)
  end

  it "resolves the Follow up Call Week One Task" do
    Tasks::FollowUpCallWeekOne.create!(
      participant: participant
    )

    expect do
      observer.after_save(second_contact)
    end.to change {
      Tasks::FollowUpCallWeekOne
        .for_participant(participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
