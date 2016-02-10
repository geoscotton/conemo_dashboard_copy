require "spec_helper"

RSpec.describe "Nurse Supervisor management", type: :feature do
  fixtures :all

  let(:admin) { users(:admin1) }

  scenario "an Admin creates a Nurse Supervisor" do
    sign_in_user admin

    visit "/admin"
    within ".sidebar-nav" do
      click_on "Nurse supervisors"
    end
    click_on "Add new"
    
    fill_in "Email", with: "nurse-supervisor-1@example.com"
    fill_in "First name", with: "Nurse"
    fill_in "Last name", with: "Supervisor"
    fill_in "Phone", with: "1234567"
    click_on "Save"

    expect(page).to have_content "Nurse supervisor successfully created"
  end

  scenario "an Admin assigns a Nurse to a Nurse Supervisor" do
  end
end
