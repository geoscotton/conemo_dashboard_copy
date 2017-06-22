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
      participant: participant
    )

    expect do
      observer.after_save(third_contact)
    end.to change {
      Tasks::FollowUpCallWeekThree
        .for_participant(participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
