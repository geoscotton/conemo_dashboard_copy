# frozen_string_literal: true
require "spec_helper"

RSpec.describe FirstAppointmentObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { FirstAppointmentObserver.instance }
  let(:first_appointment) do
    instance_double(FirstAppointment,
                    participant: participant,
                    next_contact: Time.zone.now)
  end

  it "creates a Follow up Call Week One Task " \
     "the first time a First Appointment is created" do
    NurseTask.destroy_all

    expect do
      observer.after_save(first_appointment)
      observer.after_save(first_appointment)
    end.to change {
      Tasks::FollowUpCallWeekOne
        .for_nurse_and_participant(participant.nurse, participant).count
    }.by(1)
  end

  it "creates a Follow up Call Week Three Task " \
     "the first time a First Appointment is created" do
    NurseTask.destroy_all

    expect do
      observer.after_save(first_appointment)
      observer.after_save(first_appointment)
    end.to change {
      Tasks::FollowUpCallWeekThree
        .for_nurse_and_participant(participant.nurse, participant).count
    }.by(1)
  end

  it "creates a Call to Schedule Final Appointment Task " \
     "the first time a First Appointment is created" do
    NurseTask.destroy_all

    expect do
      observer.after_save(first_appointment)
      observer.after_save(first_appointment)
    end.to change {
      Tasks::CallToScheduleFinalAppointment
        .for_nurse_and_participant(participant.nurse, participant).count
    }.by(1)
  end
end
