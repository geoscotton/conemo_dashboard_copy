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
    let(:content_access_event) do
      instance_double(ContentAccessEvent,
                      created_at: now,
                      response: Response.new).as_null_object
    end
    let(:content_access_events) do
      double("ContentAccessEvents", where: [content_access_event])
    end
    let(:session_event) do
      instance_double(SessionEvent).as_null_object
    end
    let(:session_events) do
      double("SessionEvents").tap do |s|
        allow(s).to receive_message_chain("accesses.where") { [session_event] }
      end
    end
    let(:lesson) do
      instance_double(
        Lesson,
        day_in_treatment: 1,
        title: "Lesson 1",
        content_access_events: content_access_events,
        session_events: session_events
      ).as_null_object
    end

    it "renders lesson statuses" do
      I18n.locale = "en"
      assign(:participant, participant)
      assign(:lessons, [lesson])

      render template: template

      table_exists_with_the_following_rows(
        [
          [
            "1",
            I18n.l(today, format: :long),
            "Lesson 1",
            # NOTE: the "×" below is not the "x" you type on the keyboard
            "× " + I18n.l(now, format: :long) + ": None given",
            "1",
            "1"
          ]
        ]
      )
    end
  end
end
