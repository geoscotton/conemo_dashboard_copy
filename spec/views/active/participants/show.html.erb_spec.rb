# frozen_string_literal: true

require "rails_helper"

RSpec.describe "active/participants/show", type: :view do
  let(:template) { "active/participants/show" }
  let(:now) { Time.zone.now }

  it "renders the participant's full name" do
    participant = instance_double(
      Participant,
      first_name: "Nina",
      last_name: "Simone",
      date_of_birth: Time.zone.today,
      enrollment_date: Time.zone.today,
      smartphone: instance_double(Smartphone).as_null_object,
      first_contact: instance_double(FirstContact,
                                     contact_at: now).as_null_object,
      first_appointment: instance_double(FirstAppointment,
                                         appointment_at: now).as_null_object,
      second_contact: instance_double(SecondContact,
                                      contact_at: now).as_null_object,
      third_contact: instance_double(ThirdContact,
                                     contact_at: now).as_null_object,
      final_appointment: instance_double(FinalAppointment,
                                         appointment_at: now).as_null_object
    ).as_null_object
    assign(:participant, participant)

    render template: template

    expect(rendered).to include "Nina Simone"
  end
end
