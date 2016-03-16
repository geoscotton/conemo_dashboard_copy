# frozen_string_literal: true
require "rails_helper"

RSpec.describe "third_contacts/new", type: :view do
  let(:template) { subject }
  let(:participant) do
    Participant.new(id: rand)
  end
  let(:third_contact) do
    third_contact = ThirdContact.new(participant: participant)
    participant.third_contact = third_contact

    third_contact
  end

  it "renders the heading" do
    I18n.locale = "en"
    assign(:participant, participant)
    assign(:third_contact, third_contact)

    render template: template

    expect(rendered).to include "Follow up call week 3"
  end
end
