# frozen_string_literal: true

require "rails_helper"

RSpec.describe "active/participants/show", type: :view do
  let(:template) { "active/participants/show" }
  let(:now) { Time.zone.now }

  it "renders the participant's full name" do
    participant = Participant.new(
      id: rand,
      first_name: "Nina",
      last_name: "Simone",
      date_of_birth: Time.zone.today,
      enrollment_date: Time.zone.today,
      smartphone: Smartphone.new
    )
    participant.first_contact = FirstContact.new(contact_at: now,
                                                 participant: participant)
    participant.first_appointment = FirstAppointment.new(
      appointment_at: now,
      participant: participant
    )
    participant.second_contact = SecondContact.new(contact_at: now,
                                                   participant: participant)
    participant.third_contact = ThirdContact.new(contact_at: now,
                                                 participant: participant)
    participant.final_appointment = FinalAppointment.new(
      appointment_at: now,
      participant: participant
    )
    final_call = CallToScheduleFinalAppointment.new(participant: participant,
                                                    contact_at: now)
    allow(participant).to receive(:call_to_schedule_final_appointment)
      .and_return(final_call)
    assign(:participant, participant)

    render template: template

    expect(rendered).to include "Nina Simone"
  end
end
