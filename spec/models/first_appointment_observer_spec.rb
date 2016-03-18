# frozen_string_literal: true
require "rails_helper"

RSpec.describe FirstAppointmentObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { FirstAppointmentObserver.instance }
  let(:first_appointment) do
    instance_double(FirstAppointment,
                    participant: participant,
                    next_contact: Time.zone.now)
  end

  before { NurseTask.destroy_all }

  it "creates a Follow up Call Week One Task " \
     "the first time a First Appointment is created" do
    expect do
      observer.after_save(first_appointment)
      observer.after_save(first_appointment)
    end.to change {
      Tasks::FollowUpCallWeekOne
        .for_participant(participant).count
    }.by(1)
  end

  it "creates a Follow up Call Week Three Task " \
     "the first time a First Appointment is created" do
    expect do
      observer.after_save(first_appointment)
      observer.after_save(first_appointment)
    end.to change {
      Tasks::FollowUpCallWeekThree
        .for_participant(participant).count
    }.by(1)
  end

  it "creates a Call to Schedule Final Appointment Task " \
     "the first time a First Appointment is created" do
    expect do
      observer.after_save(first_appointment)
      observer.after_save(first_appointment)
    end.to change {
      Tasks::CallToScheduleFinalAppointment
        .for_participant(participant).count
    }.by(1)
  end

  it "resolves the First in Person Appointment Task" do
    Tasks::InitialInPersonAppointment.create!(participant: participant)

    expect do
      observer.after_create(first_appointment)
    end.to change {
      Tasks::InitialInPersonAppointment
        .for_participant(participant)
        .last
        .status
    }.from(NurseTask::STATUSES.active).to(NurseTask::STATUSES.resolved)
  end
end
