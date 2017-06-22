# frozen_string_literal: true
require "rails_helper"

RSpec.describe NonAdherenceCallObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { NonAdherenceCallObserver.instance }
  let(:non_adherence) do
    instance_double(NonAdherenceCall, participant: participant)
  end

  before { NurseTask.destroy_all }

  it "resolves the Non Adherence Call Task" do
    Tasks::NonAdherenceCall.create!(participant: participant)

    expect do
      observer.after_save(non_adherence)
    end.to change {
      Tasks::NonAdherenceCall
        .for_participant(participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
