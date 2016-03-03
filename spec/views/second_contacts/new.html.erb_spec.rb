# frozen_string_literal: true
require "rails_helper"

RSpec.describe "second_contacts/new", type: :view do
  fixtures :participants

  let(:template) { subject }
  let(:participant) { Participant.first }
  let(:second_contact) { SecondContact.new(participant: participant) }

  it "renders a submit button for the form" do
    assign(:second_contact, second_contact)
    assign(:participant, participant)

    render template: template

    expect(rendered).to include I18n.t("conemo.views.shared.save_button")
  end
end
