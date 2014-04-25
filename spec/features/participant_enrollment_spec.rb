require "spec_helper"

describe "participant enrollment" do
  fixtures(
    :users, :participants
  )

  before do
    sign_in_user users(:admin1)
    visit "/en/pending/participants"
  end

  it "should show a list of pending participants" do
    expect(page).to have_text(participants(:participant1).study_identifier)
  end
end
