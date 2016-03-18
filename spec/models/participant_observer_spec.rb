# frozen_string_literal: true
require "rails_helper"

RSpec.describe ParticipantObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }

  it "creates a Confirmation Call Task the first time a Nurse is assigned" do
    NurseTask.destroy_all
    observer = ParticipantObserver.instance

    expect do
      observer.after_save(participant)
      observer.after_save(participant)
    end.to change {
      Tasks::ConfirmationCall.for_participant(participant).count
    }.by(1)
  end
end
