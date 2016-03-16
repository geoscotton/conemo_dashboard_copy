# frozen_string_literal: true
require "rails_helper"

RSpec.describe "final_appointments/new", type: :view do
  let(:template) { subject }
  let(:final_appointment) { FinalAppointment.new }
  let(:participant) do
    instance_double(Participant,
                    final_appointment: final_appointment).as_null_object
  end

  it "renders the heading" do
    I18n.locale = "en"
    assign(:participant, participant)
    assign(:final_appointment, final_appointment)

    render template: template

    expect(rendered).to include "Final in person appointment"
  end
end
