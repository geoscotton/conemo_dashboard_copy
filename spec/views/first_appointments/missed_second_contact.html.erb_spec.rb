# frozen_string_literal: true
require "rails_helper"

RSpec.describe "first_appointments/missed_second_contact", type: :view do
  let(:template) { subject }
  let(:first_appointment) { FirstAppointment.new }
  let(:participant) do
    instance_double(Participant, first_appointment: first_appointment)
  end

  it "renders the heading" do
    I18n.locale = "en"
    assign(:participant, participant)
    assign(:first_appointment, first_appointment)

    render template: template

    expect(rendered).to include "Reschedule follow up call week 1"
  end
end
