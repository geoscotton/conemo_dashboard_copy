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
      nurse: participant.nurse,
      participant: participant
    )

    expect do
      observer.after_create(final_appointment)
    end.to change {
      Tasks::FinalInPersonAppointment
        .for_nurse_and_participant(participant.nurse, participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
