# frozen_string_literal: true
require "rails_helper"

RSpec.describe HelpRequestCallObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { HelpRequestCallObserver.instance }
  let(:help_request) do
    instance_double(HelpRequestCall, participant: participant)
  end

  before { NurseTask.destroy_all }

  it "resolves the Help Request Task" do
    Tasks::HelpRequest.create!(participant: participant)

    expect do
      observer.after_create(help_request)
    end.to change {
      Tasks::HelpRequest
        .for_participant(participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
