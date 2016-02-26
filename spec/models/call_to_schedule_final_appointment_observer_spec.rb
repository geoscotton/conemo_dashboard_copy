# frozen_string_literal: true
require "spec_helper"

RSpec.describe CallToScheduleFinalAppointmentObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { CallToScheduleFinalAppointmentObserver.instance }
  let(:call_to_schedule_final_appointment) do
    instance_double(CallToScheduleFinalAppointment,
                    participant: participant,
                    final_appointment_at: Time.zone.now)
  end

  it "creates a Final in Person Appointment Task " \
     "the first time a Call to Schedule Final Appointment is created" do
    NurseTask.destroy_all

    expect do
      observer.after_save(call_to_schedule_final_appointment)
      observer.after_save(call_to_schedule_final_appointment)
    end.to change {
      Tasks::FinalInPersonAppointment
        .for_nurse_and_participant(participant.nurse, participant).count
    }.by(1)
  end
end
