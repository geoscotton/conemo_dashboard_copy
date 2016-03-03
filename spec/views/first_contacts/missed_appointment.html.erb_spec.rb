# frozen_string_literal: true
require "rails_helper"

RSpec.describe "first_contacts/missed_appointment", type: :view do
  let(:template) { subject }
  let(:first_contact) { FirstContact.new }
  let(:participant) { instance_double(Participant) }

  it "renders the header" do
    I18n.locale = "en"
    assign(:first_contact, first_contact)
    assign(:participant, participant)

    render template: template

    expect(rendered).to include "Reschedule"
  end
end
