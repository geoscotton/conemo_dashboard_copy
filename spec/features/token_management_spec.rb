# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Token management", type: :feature do
  fixtures :all

  let(:en_admin) { users(:admin1) }

  scenario "an Admin views a Participant's tokens" do
    sign_in_user en_admin

    visit "/admin?locale=en"
    within ".sidebar-nav" do
      click_on "Participant"
    end
    within ".participant_row:first .tokens_field" do
      click_on "Show"
    end

    expect(page).to have_content "Manage tokens"
  end
end
