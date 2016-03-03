# frozen_string_literal: true
require "rails_helper"

RSpec.describe "participants/new", type: :view do
  let(:template) { subject }
  let(:participant) { Participant.new }

  it "renders the heading" do
    I18n.locale = "en"
    assign(:participant, participant)

    render template: template

    expect(rendered).to include "Enroll New Participant"
  end
end
