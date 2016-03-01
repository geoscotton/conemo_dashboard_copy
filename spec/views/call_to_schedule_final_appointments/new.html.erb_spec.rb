# frozen_string_literal: true

require "rails_helper"

RSpec.describe "call_to_schedule_final_appointments/new", type: :view do
  fixtures :participants

  let(:template) { subject }
  let(:participant) { Participant.first }
  let(:call_to_schedule) do
    CallToScheduleFinalAppointment.new(participant: participant)
  end

  it "renders a submit button for the form" do
    assign(:call_to_schedule_final_appointment, call_to_schedule)
    assign(:participant, participant)

    render template: template

    expect(rendered).to include I18n.t("conemo.views.shared.save_button")
  end
end
