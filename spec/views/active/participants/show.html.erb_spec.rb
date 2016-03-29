# frozen_string_literal: true

require "rails_helper"

RSpec.describe "active/participants/show", type: :view do
  let(:template) { "active/participants/show" }
  let(:now) { Time.zone.now }
  let(:today) { Time.zone.today }
  let(:nurse) { Nurse.new(id: rand) }

  it "renders the participant's date of birth" do
    allow(view).to receive(:current_user) { nurse }
    participant = Participant.new(
      id: rand,
      first_name: "Nina",
      last_name: "Simone",
      date_of_birth: today,
      enrollment_date: today,
      smartphone: Smartphone.new,
      nurse: nurse
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

    expect(rendered).to include I18n.l(today, format: :long)
  end
end
