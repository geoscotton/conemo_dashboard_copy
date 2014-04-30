require "spec_helper"

describe "participant management" do
  fixtures(
    :users, :participants
  )

  before(:each) do
    sign_in_user users(:admin1)
  end

  let(:participant) { participants(:active_participant) }
  let(:nurse) { users(:nurse1) }

  it "should show a list of active participants" do
    visit "/en/active/participants"

    expect(page).to have_text(participant.study_identifier)
  end

  describe "first contact" do

    it "creates a first contact for a participant and shows the contact_at date on the index" do
      visit "/en/active/participants"

      click_on "first_contact_#{participant.id}"

      expect(page).to have_text "Input First Contact Information"

      fill_in "First appointment location", with: "location string for first appointment"
      click_on "Save"

      expect(page).to have_text "Successfully created first contact"
      expect(page).to have_text participant.first_contact.contact_at.to_s(:long)
    end
  end

  describe "first appointment" do

    fixtures(
      :first_contacts
    )

    it "renders a first appointment link for a participant" do
      visit "/en/active/participants"

      expect(page).to have_text participant.first_contact.first_appointment_at.to_s(:long)
    end

    it "creates a first appointment form" do
      visit "/en/active/participants"

      click_on "first_appointment_#{participant.id}"

      expect(page).to have_text "Input First Appointment"
    end

    it "takes the user to the smartphone form after successful first appointment input" do
      visit "/en/active/participants"

      click_on "first_appointment_#{participant.id}"

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
      select "5", from: "first_appointment_nurse_participant_evaluation_attributes_smartphone_comfort"
      select "5", from: "first_appointment_nurse_participant_evaluation_attributes_participant_session_engagement"
      select "5", from: "first_appointment_nurse_participant_evaluation_attributes_app_usage_prediction"
      click_on "Save"

      expect(page).to have_text "Successfully created first appointment"
      expect(page).to have_text "Input Smartphone"
    end
  end
end