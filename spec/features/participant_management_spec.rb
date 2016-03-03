# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Participant Management", type: :feature do
  fixtures :users, :participants, :first_contacts

  context "For Nurses" do
    let(:portuguese_active_participant2) { participants(:portuguese_active_participant2) }
    let(:portuguese_active_participant) { participants(:portuguese_active_participant) }
    let(:english_active_participant) { participants(:english_active_participant) }
    let(:portuguese_nurse) { users(:portuguese_nurse) }
    let(:portuguese_nurse2) { users(:portuguese_nurse2) }
    let(:participant) { participants(:active_participant) }
    let(:es_active_participant) { participants(:es_active_participant) }
    let(:english_active_participant) { participants(:english_active_participant) }
    let(:en_inactive_participant) { participants(:english_inactive_participant) }

    describe "confirmation call" do
      it "creates a confirmation call for a participant" do
        sign_in_user participant.nurse
        FirstContact.destroy_all
        visit "/en/participants/#{participant.id}/first_contact/new"

        expect(page).to have_text "Confirmation call"

        select "Health unit", from: "Initial in person appointment location"
        click_on "Save"

        expect(page).to have_text "Successfully created first contact"
      end
    end

    describe "Initial in person appointment" do
      it "takes the user to the smartphone form after successful first appointment input" do
        sign_in_user participant.nurse
        visit "/en/participants/#{participant.id}/first_appointment/new"

        expect(page).to have_text "Initial in person appointment"

        select "2014", from: "first_appointment_appointment_at_1i"
        select "August", from: "first_appointment_appointment_at_2i"
        select "1", from: "first_appointment_appointment_at_3i"
        select "20", from: "first_appointment_appointment_at_4i"
        select "20", from: "first_appointment_appointment_at_5i"
        fill_in "Location of appointment", with: "Location"
        fill_in "first_appointment_session_length", with: "5"
        select "2014", from: "first_appointment_next_contact_1i"
        select "August", from: "first_appointment_next_contact_2i"
        select "1", from: "first_appointment_next_contact_3i"
        select "22", from: "first_appointment_next_contact_4i"
        select "20", from: "first_appointment_next_contact_5i"
        select "3", from: "first_appointment_smartphone_comfort"
        select "3", from: "first_appointment_participant_session_engagement"
        select "3", from: "first_appointment_app_usage_prediction"
        click_on "Save"

        expect(page).to have_text "Input Smartphone"
      end
    end

    it "should only show active participants that belong to a specific nurse" do
      sign_in_user users(:portuguese_nurse)
      expect(page).to have_text(portuguese_active_participant.study_identifier)
    end

    it "should not show active participants managed by another nurse" do
      sign_in_user users(:portuguese_nurse)
      expect(page).to_not have_text(portuguese_active_participant2.study_identifier)
    end
  end
end
