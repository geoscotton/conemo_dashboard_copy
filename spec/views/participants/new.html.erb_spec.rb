# frozen_string_literal: true
require "rails_helper"

RSpec.describe "participants/new", type: :view do
  let(:template) { subject }
  let(:participant) { Participant.new }

  it "renders the heading" do
    I18n.locale = "en"
    assign(:participant, participant)
    allow(view).to receive(:current_user)
      .and_return(instance_double(User, nurse?: false))

    render template: template

    expect(rendered).to include "Participant"
  end
end
