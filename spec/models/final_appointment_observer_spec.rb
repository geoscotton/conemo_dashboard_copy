# frozen_string_literal: true
require "rails_helper"

RSpec.describe FinalAppointmentObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { FinalAppointmentObserver.instance }
  let(:final_appointment) do
    instance_double(FinalAppointment, participant: participant)
  end

  before { NurseTask.destroy_all }

  it "resolves the Final in Person Appointment Task" do
    Tasks::FinalInPersonAppointment.create!(
      participant: participant
    )

    expect do
      observer.after_save(final_appointment)
    end.to change {
      Tasks::FinalInPersonAppointment
        .for_participant(participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end

  it "completes the Participant" do
    expect do
      observer.after_save(final_appointment)
    end.to change {
      participant.status
    }.from(Participant::ACTIVE).to(Participant::COMPLETED)
  end
end
