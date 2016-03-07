# frozen_string_literal: true
require "rails_helper"

RSpec.describe ThirdContactObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { ThirdContactObserver.instance }
  let(:third_contact) do
    instance_double(ThirdContact, participant: participant)
  end

  it "resolves the Follow up Call Week Three Task" do
    Tasks::FollowUpCallWeekThree.create!(
      nurse: participant.nurse,
      participant: participant
    )

    expect do
      observer.after_create(third_contact)
    end.to change {
      Tasks::FollowUpCallWeekThree
        .for_nurse_and_participant(participant.nurse, participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
