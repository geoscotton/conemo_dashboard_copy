# frozen_string_literal: true
require "rails_helper"

RSpec.describe "participant enrollment", type: :feature do
  fixtures :all

  before(:each) do
    sign_in_user users(:admin1)
  end

  let(:unassigned_participant) { participants(:en_unassigned_participant) }
  let(:nurse) { users(:nurse1) }

  it "should show a list of pending participants" do
    visit "/en/pending/participants"
    expect(page).to have_text(unassigned_participant.study_identifier)
  end

  it "should enroll a new participant" do
    visit "/en/participants/new"

    expect(page).to have_text "Participant"

    fill_in "First name", with: "Joe"
    fill_in "Last name", with: "Blow"
    fill_in "Participant ID", with: "14"
    select "unit 2", from: "Family health unit"
    fill_in "participant_phone", with: "224-444-5555"
    select "2011", from: "participant_date_of_birth_1i"
    select "March", from: "participant_date_of_birth_2i"
    select "1", from: "participant_date_of_birth_3i"
    fill_in "Address", with: "Address of participant"
    choose "participant_gender_male"
    click_on "Save"

    expect(page).to have_text "14"
  end

  it "should activate an eligible participant" do
    visit "/en/pending/participants"

    expect(page).to have_text unassigned_participant.study_identifier

    within "#participant-#{unassigned_participant.id}" do
      click_on "Activate"
    end

    expect(page).to have_text "Successfully activated participant"
  end
end
