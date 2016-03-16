# frozen_string_literal: true
require "rails_helper"

RSpec.describe "active/participants/report", type: :view do
  let(:template) { "active/participants/report" }
  let(:now) { Time.zone.now }
  let(:today) { Time.zone.today }
  let(:first_appointment) do
    FirstAppointment.new(appointment_at: now)
  end
  let(:participant) do
    participant = Participant.new(id: rand,
                                  help_messages: [],
                                  logins: [],
                                  patient_contacts: [],
                                  first_appointment: first_appointment)
    allow(participant).to receive(:start_date) { today }

    participant
  end
  let(:second_contact) do
    second_contact = SecondContact.new(contact_at: now,
                                       participant: participant)
    participant.second_contact = second_contact

    second_contact
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

    def stub_participant
      I18n.locale = "en"
      assign(:participant, participant)
    end

    it "renders lesson statuses" do
      stub_participant
      assign(:lessons, [lesson])
      assign(:participant_contacts, [])

      render template: template

      table_exists_with_the_following_rows(
        [
          ["1", I18n.l(today + release_day - 1, format: :long), "Lesson 1"]
        ]
      )
    end

    it "renders the contact points" do
      stub_participant
      assign(:lessons, [])
      assign(:participant_contacts,
             [
               ParticipantContactPresenter.new(first_appointment),
               ParticipantContactPresenter.new(second_contact)
             ])

      render template: template

      table_exists_with_the_following_rows(
        [
          ["Initial in person appointment #{I18n.l(now, format: :long)}"],
          ["Follow up call week 1 #{I18n.l(now, format: :long)}"]
        ]
      )
    end
  end
end
