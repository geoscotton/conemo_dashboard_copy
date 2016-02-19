require "spec_helper"

RSpec.describe "Token management", type: :feature do
  fixtures :users, :participants

  let(:en_admin) { users(:admin1) }

  scenario "an Admin views a Participant's tokens" do
    sign_in_user en_admin

    visit "/admin"
    within ".sidebar-nav" do
      click_on "Participants"
    end
    within ".participant_row:first .tokens_field" do
      click_on "Show"
    end
    
    expect(page).to have_content "Manage tokens"
  end
end
