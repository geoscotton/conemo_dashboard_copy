# frozen_string_literal: true
require "rails_helper"

RSpec.describe FirstContactObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { FirstContactObserver.instance }
  let(:first_contact) do
    instance_double(FirstContact,
                    participant: participant,
                    first_appointment_at: Time.zone.now)
  end

  before { NurseTask.destroy_all }

  it "creates an Initial In Person Appointment Task " \
     "the first time a Nurse is assigned" do
    expect do
      observer.after_save(first_contact)
      observer.after_save(first_contact)
    end.to change {
      Tasks::InitialInPersonAppointment
        .for_nurse_and_participant(participant.nurse, participant).count
    }.by(1)
  end

  it "resolves the Confirmation Call Task" do
    Tasks::ConfirmationCall.create!(
      nurse: participant.nurse,
      participant: participant
    )

    expect do
      observer.after_create(first_contact)
    end.to change {
      Tasks::ConfirmationCall
        .for_nurse_and_participant(participant.nurse, participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
