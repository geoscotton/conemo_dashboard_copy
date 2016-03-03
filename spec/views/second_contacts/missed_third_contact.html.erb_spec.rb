# frozen_string_literal: true
require "rails_helper"

RSpec.describe "second_contacts/missed_third_contact", type: :view do
  let(:template) { subject }
  let(:second_contact) { SecondContact.new }
  let(:participant) do
    instance_double(Participant, second_contact: second_contact)
  end

  it "renders the heading" do
    I18n.locale = "en"
    assign(:participant, participant)
    assign(:second_contact, second_contact)

    render template: template

    expect(rendered).to include "Reschedule follow up call week 3"
  end
end
