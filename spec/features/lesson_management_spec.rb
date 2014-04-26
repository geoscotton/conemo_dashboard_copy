require "spec_helper"

describe "lesson management" do
  fixtures :users

  before do
    sign_in_user users(:admin1)
    visit "/en/lessons"
  end

  it "should allow an admin to create a lesson with HTML content" do
    click_on "Add Lesson"
    fill_in "Title", with: "Lesson 1"
    fill_in "Day in treatment", with: 1
    click_on "Create Lesson"

    expect(page).to have_text("Lesson saved")
    expect(page).to have_text("Lesson 1")
  end
end
