require "spec_helper"

describe "participant enrollment" do
  fixtures(
    :users, :participants
  )

  before(:each) do
    sign_in_user users(:admin1)
  end

  let(:participant) { participants(:participant1) }
  let(:nurse) { users(:nurse1) }

  it "should show a list of pending participants" do
    visit "/en/pending/participants"
    expect(page).to have_text(participant.study_identifier)
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
    check "diabetes"
    click_on "Save"

    expect(page).to have_text "Successfully created participant"
  end

  it "should update an ineligible participant and remove them from the pending index" do
    visit "/en/pending/participants"

    expect(page).to have_text participant.study_identifier

    click_on "disqualify_#{participant.id}"

    expect(page).to have_text "Successfully updated participant"
    pending_node = page.find("#pending")
    expect(pending_node).to_not have_text participant.study_identifier
    ineligible_node = page.find("#ineligible")
    expect(ineligible_node).to have_text participant.study_identifier
  end

  it "should activate an eligible participant and assign them to a nurse" do
    visit "/en/pending/participants"

    expect(page).to have_text participant.study_identifier

    click_on "activate_#{participant.id}"

    expect(page).to have_text "Assign nurse to activate participant #{participant.first_name} #{participant.last_name}"

    select nurse.last_name, from: "participant_nurse_id"
    click_on "Save"

    expect(page).to have_text "Successfully updated participant"
    expect(page).to have_text participant.study_identifier
  end
end
