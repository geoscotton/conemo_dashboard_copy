require "spec_helper"

describe "Participant Management" do
  context "For Admins" do
    fixtures(
      :users, :participants, :smartphones
    )

    before(:each) do
      sign_in_user users(:admin1)
    end

    let(:participant) { participants(:active_participant) }
    let(:es_active_participant) { participants(:es_active_participant) }
    let(:english_active_participant) { participants(:english_active_participant) }
    let(:en_inactive_participant) { participants(:english_inactive_participant) }
    let(:admin) { users(:admin1) }

    it "should show a list of active participants within the locale" do
      visit "/en/active/participants"

      expect(page).to have_text(english_active_participant.study_identifier)
    end

    it "should not show active participants within a different locale" do
      visit "/en/active/participants"

      expect(page).to_not have_text(es_active_participant.study_identifier)
    end

    it "should not show inactive participants" do
      visit "/en/active/participants"
      expect(page).to_not have_text(en_inactive_participant.study_identifier)
    end

    describe "first contact" do

      it "creates a first contact for a participant and shows the contact_at date on the index" do
        visit "/en/active/participants"

        click_on "first_contact_#{participant.id}"

        expect(page).to have_text "First Contact"

        fill_in "First appointment location", with: "location string for first appointment"
        click_on "Save"

        expect(page).to have_text participant.first_contact.contact_at.in_time_zone(participant.nurse.timezone).to_s(:short)
      end
    end

    describe "first appointment" do

      fixtures(
        :first_contacts
      )

      it "renders a first appointment link for a participant" do
        visit "/en/active/participants"

        expect(page).to have_text participant.first_contact.first_appointment_at.in_time_zone(participant.nurse.timezone).to_s(:short)
      end

      it "creates a first appointment form" do
        visit "/en/active/participants"

        click_on "appointment_#{participant.id}"

        expect(page).to have_text "First Appointment"
      end

      it "takes the user to the smartphone form after successful first appointment input" do
        visit "/en/active/participants"

        click_on "appointment_#{participant.id}"

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
  end
  context "For Nurses" do
    fixtures(
      :users, :participants
    )

    let(:portuguese_active_participant2) { participants(:portuguese_active_participant2) }
    let(:portuguese_active_participant) { participants(:portuguese_active_participant) }
    let(:english_active_participant) { participants(:english_active_participant) }
    let(:portuguese_nurse) { users(:portuguese_nurse) }
    let(:portuguese_nurse2) { users(:portuguese_nurse2) }

    it "should only show active participants that belong to a specific nurse" do
      sign_in_user users(:portuguese_nurse)
      visit "/pt-BR/active/participants"
      expect(page).to have_text(portuguese_active_participant.study_identifier)
    end

    it "should not show active participants managed by another nurse" do
      sign_in_user users(:portuguese_nurse)
      visit "/en/active/participants"
      expect(page).to_not have_text(portuguese_active_participant2.study_identifier)
    end
  end
end
