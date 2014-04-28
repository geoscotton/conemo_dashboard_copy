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
    fill_in("First name", with: "Joe")
    fill_in("Last name", with: "Blow")
    fill_in("Study Identifier", with: "s14")
    fill_in("Family health unit name", with: "Healthy!")
    fill_in("Family record number", with: "12345")
    fill_in("Phone", with: "224-444-5555")
    fill_in("Email", with: "joe")
    select '2011/01/01', from: 'Date of birth'
    fill_in("Address", with: "Joe")
    select '2011/01/01', from: 'Enrollment date'
    fill_in("gender", with: "Joe")
    fill_in("Key chronic disorder", with: "Joe")
    click_on("Save")
    expect(page).to have_text "Successfully created participant"
  end
end
