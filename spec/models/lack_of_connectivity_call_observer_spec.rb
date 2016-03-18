# frozen_string_literal: true
require "rails_helper"

RSpec.describe LackOfConnectivityCallObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { LackOfConnectivityCallObserver.instance }
  let(:lack_of_connectivity) do
    instance_double(LackOfConnectivityCall, participant: participant)
  end

  before { NurseTask.destroy_all }

  it "resolves the Lack of Connectivity Call Task" do
    Tasks::LackOfConnectivityCall.create!(participant: participant)

    expect do
      observer.after_create(lack_of_connectivity)
    end.to change {
      Tasks::LackOfConnectivityCall
        .for_participant(participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
