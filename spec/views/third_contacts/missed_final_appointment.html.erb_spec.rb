# frozen_string_literal: true
require "rails_helper"

RSpec.describe "third_contacts/missed_final_appointment", type: :view do
  let(:template) { subject }
  let(:third_contact) { ThirdContact.new }
  let(:participant) do
    instance_double(Participant, third_contact: third_contact)
  end

  it "renders the heading" do
    I18n.locale = "en"
    assign(:participant, participant)
    assign(:third_contact, third_contact)

    render template: template

    expect(rendered).to include "Reschedule final in person appointment"
  end
end
