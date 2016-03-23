# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Nurse Supervisor management", type: :feature do
  fixtures :all

  let(:en_admin) { users(:admin1) }
  let(:en_nurse_supervisor) { users(:en_nurse_supervisor_1) }

  scenario "an Admin creates a Nurse Supervisor" do
    sign_in_user en_admin

    visit "/admin"
    within ".sidebar-nav" do
      click_on "Nurse supervisors"
    end
    click_on "Add new"

    fill_in "Email", with: "awesome-nurse-supervisor@example.com"
    fill_in "First name", with: "Nurse"
    fill_in "Last name", with: "Supervisor"
    fill_in "Phone", with: "1234567"
    click_on "Save"

    expect(page).to have_content "Nurse supervisor successfully created"
  end

  scenario "Admin creates and assigns Nurse to a Nurse Supervisor", js: true do
    sign_in_user en_admin

    visit "/admin"
    within ".sidebar-nav" do
      click_on "Nurses"
    end
    click_on "Add new"

    fill_in "Email", with: "nurse-1@example.com"
    fill_in "First name", with: "Nurse"
    fill_in "Last name", with: "Murse"
    fill_in "Phone", with: "1234567"
    within ".nurse_supervisor_field" do
      find(".ra-filtering-select-input").set(
        en_nurse_supervisor.last_and_first_name
      )
    end
    click_on "Save"

    expect(page).to have_content "Nurse successfully created"
  end
end
