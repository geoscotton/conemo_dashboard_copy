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
    contacts = [
      FirstContact.new(contact_at: now, participant: participant),
      FirstAppointment.new(appointment_at: now, participant: participant),
      SecondContact.new(contact_at: now, participant: participant),
      ThirdContact.new(contact_at: now, participant: participant),
      FinalAppointment.new(appointment_at: now, participant: participant),
      CallToScheduleFinalAppointment.new(participant: participant,
                                         contact_at: now)
    ].map do |contact|
      ParticipantContactPresenter.new(contact)
    end
    assign(:participant, participant)
    assign(:participant_contacts, contacts)

    render template: template

    expect(rendered).to include "Nina Simone"
  end
end
