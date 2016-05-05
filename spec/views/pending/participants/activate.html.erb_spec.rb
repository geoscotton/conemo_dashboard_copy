# frozen_string_literal: true
require "rails_helper"

RSpec.describe "pending/participants/activate", type: :view do
  let(:template) { "pending/participants/activate" }
  let(:participant) do
    Participant.new(first_name: "x", last_name: "y")
  end

  it "renders the participant's name" do
    assign(:participant, participant)
    assign(:nurses, [])

    render template: template

    expect(rendered).to have_text "x y"
  end
end
