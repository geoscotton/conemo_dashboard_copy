require "spec_helper"

describe "participant enrollment" do
  fixtures(
    :users, :participants
  )

  before(:each) do
    sign_in_user users(:admin1)
  end

  it "should show a list of pending participants" do
    visit "/en/pending/participants"
    expect(page).to have_text(participants(:participant1).study_identifier)
  end

  it "should enroll a new participant" do
    visit "/en/participants/new"
    expect(page).to have_text "Enroll New Participant"
    fill_in "First name", with: "Joe"
    fill_in "Last name", with: "Blow"
    fill_in("Study Identifier", with: "s14")
    fill_in "Family health unit name", with: "Healthy!"
    fill_in "Family record number", with: "12345"
    fill_in "participant_phone", with: "224-444-5555"
    fill_in("Email", with: "joe")
    select "2011", from: "participant_date_of_birth_1i"
    select "March", from: "participant_date_of_birth_2i"
    select "1", from: "participant_date_of_birth_3i"
    fill_in "Address", with: "Address of participant"
    select "2014", from: "participant_enrollment_date_1i"
    select "August", from: "participant_enrollment_date_2i"
    select "1", from: "participant_enrollment_date_3i"
    choose "participant_gender_male"
    choose "participant_key_chronic_disorder_diabetes"
    click_on("Save")
    expect(page).to have_text "Successfully created participant"
  end
end
