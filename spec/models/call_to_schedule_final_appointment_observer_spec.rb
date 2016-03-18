# frozen_string_literal: true
require "rails_helper"

RSpec.describe CallToScheduleFinalAppointmentObserver do
  fixtures :all

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
        .for_participant(participant).count
    }.by(1)
  end

  it "resolves the Call to Schedule Final Appointment Task" do
    Tasks::CallToScheduleFinalAppointment.create!(
      participant: participant
    )

    expect do
      observer.after_create(call_to_schedule_final_appointment)
    end.to change {
      Tasks::CallToScheduleFinalAppointment
        .for_participant(participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
