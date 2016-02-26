# frozen_string_literal: true
require "spec_helper"

describe "Participant Report", type: :feature do
  fixtures :all

  let(:participant) { participants(:active_participant) }
  let(:admin) { users(:admin1) }

  before(:each) do
    sign_in_user users(:admin1)
    visit "en/active/report/#{participant.id}"
  end

  it "renders the report page" do
    expect(page).to have_content("Overall Status")
  end

  it "displays lesson modal with correct responses" do
    within '#modal-0' do
      expect(page).to have_content("How old are you?")
    end
  end
end
