# frozen_string_literal: true
require "rails_helper"

RSpec.describe "patient_contacts/new", type: :view do
  fixtures :participants

  let(:template) { subject }
  let(:patient_contact) { PatientContact.new }
  let(:participant) { Participant.first }

  it "renders the heading" do
    I18n.locale = "en"
    assign(:patient_contact, patient_contact)
    assign(:participant, participant)
    assign(:participant_contacts, [])

    render template: template

    expect(rendered).to include "Create Note for Jane Doe"
  end
end
