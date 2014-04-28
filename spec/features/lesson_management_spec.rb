require "spec_helper"

describe "lesson management" do
  fixtures :users, :"bit_core/slideshows", :lessons

  before do
    sign_in_user users(:admin1)
    visit "/en/lessons"
  end

  it "should allow an admin to create a lesson" do
    click_on "Add Lesson"
    fill_in "Title", with: "Lesson 1"
    fill_in "Day in treatment", with: 1
    click_on "Create Lesson"

    expect(page).to have_text("Lesson saved")
    expect(page).to have_text("Lesson 1")
  end

  it "should allow an admin to create a lesson slide with HTML content" do
    click_on lessons(:day1).title
    click_on "Add Slide"
    fill_in "Title", with: "Slide 1"
    fill_in "Body", with: "<p>I'm a slide dawg</p>"
    click_on "Create Slide"

    expect(page).to have_text("Slide saved")
    expect(page).to have_text("Slide 1")
  end
end
