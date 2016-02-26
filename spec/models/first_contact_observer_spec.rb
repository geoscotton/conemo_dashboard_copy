# frozen_string_literal: true
require "spec_helper"

RSpec.describe FirstContactObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }

  it "creates an Initial In Person Appointment Task " \
     "the first time a Nurse is assigned" do
    NurseTask.destroy_all
    observer = FirstContactObserver.instance
    first_contact = instance_double(FirstContact,
                                    participant: participant,
                                    first_appointment_at: Time.zone.now)

    expect do
      observer.after_save(first_contact)
      observer.after_save(first_contact)
    end.to change {
      Tasks::InitialInPersonAppointment
        .for_nurse_and_participant(participant.nurse, participant).count
    }.by(1)
  end
end
