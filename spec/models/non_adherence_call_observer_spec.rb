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
    Tasks::NonAdherenceCall.create!(
      nurse: participant.nurse,
      participant: participant
    )

    expect do
      observer.after_create(non_adherence)
    end.to change {
      Tasks::NonAdherenceCall
        .for_nurse_and_participant(participant.nurse, participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
