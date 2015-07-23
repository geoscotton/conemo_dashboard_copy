require "spec_helper"

describe "lesson management" do
  fixtures :all

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

  it "should allow an admin to update a lesson" do
    click_on "edit-lesson-#{ lessons(:day1).id }"
    fill_in "Title", with: "Edited lesson"
    fill_in "Day in treatment", with: 8
    click_on "Update Lesson"

    expect(page).to have_text("Lesson saved")
    expect(page).to have_text("Edited lesson")
  end

  it "should allow an admin to destroy a lesson" do
    click_on "destroy-lesson-#{ lessons(:day1).id }"

    expect(page).to have_text("Lesson deleted")
    expect(page).not_to have_text(lessons(:day1).title)
  end

  it "should allow an admin to create a lesson slide with HTML content" do
    click_on lessons(:day1).title
    click_on "Add Slide"
    fill_in "Title", with: "Slide 2"
    fill_in "Body", with: "<p>I'm a slide dawg</p>"
    click_on "Create Slide"

    expect(page).to have_text("Slide saved")

    click_on "Slide 2"

    expect(page).to have_text("I'm a slide dawg")
  end

  it "should allow an admin to update a lesson slide" do
    click_on lessons(:day1).title
    click_on "edit-slide-#{ bit_core_slides(:day1_slide1).id }"
    fill_in "Title", with: "Edited slide"
    fill_in "Body", with: "<span>edited slide</span>"
    click_on "Update Slide"

    expect(page).to have_text("Slide saved")

    click_on "Edited slide"

    expect(page).to have_text("edited slide")
  end

  it "should allow an admin to destroy a lesson slide" do
    click_on lessons(:day1).title
    click_on "destroy-slide-#{ bit_core_slides(:day1_slide1).id }"

    expect(page).to have_text("Slide deleted")
    expect(page).not_to have_text(bit_core_slides(:day1_slide1).title)
  end
end
