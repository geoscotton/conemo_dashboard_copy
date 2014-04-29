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

  it "creates a first contact for a participant and shows the contact_at date on the index" do
    visit "/en/active/participants"
    click_on "first_contact_#{participant.id}"
    expect(page).to have_text "Input First Contact Information"
    fill_in "First appointment location", with: "location string for first appointment"
    click_on "Save"
    expect(page).to have_text "Successfully created first contact"
    expect(page).to have_text participant.first_contact.contact_at
  end
end