# frozen_string_literal: true
require "rails_helper"

RSpec.describe "active/participants/report", type: :view do
  let(:template) { "active/participants/report" }
  let(:now) { Time.zone.now }
  let(:today) { Time.zone.today }
  let(:first_appointment) do
    instance_double(FirstAppointment, appointment_at: now).as_null_object
  end
  let(:second_contact) do
    instance_double(SecondContact, contact_at: now).as_null_object
  end
  let(:participant) do
    instance_double(Participant,
                    id: rand,
                    start_date: today,
                    help_messages: [],
                    logins: [],
                    patient_contacts: [],
                    first_appointment: first_appointment,
                    second_contact: second_contact).as_null_object
  end

  describe "the lessons table" do
    let(:release_day) { 3 }
    let(:lesson) do
      instance_double(
        Lesson,
        day_in_treatment: release_day,
        title: "Lesson 1"
      ).as_null_object
    end

    it "renders lesson statuses" do
      I18n.locale = "en"
      assign(:participant, participant)
      assign(:lessons, [lesson])

      render template: template

      table_exists_with_the_following_rows(
        [
          ["1", I18n.l(today + release_day - 1, format: :long), "Lesson 1"]
        ]
      )
    end
  end
end
