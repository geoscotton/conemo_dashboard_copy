# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Participant activation", type: :feature do
  fixtures :all

  let(:en_admin) { users(:admin1) }
  let(:en_pending_participant) { participants(:en_pending_participant) }

  scenario "an Admin activates a Participant" do
    expect(en_pending_participant.nurse).to be_nil
    sign_in_user en_admin
    visit "/en/pending/participants"
    click_on "activate_#{en_pending_participant.id}"

    expect do
      click_on "Save"
    end.to change { Participant.active.count }.by(1)
    expect(Participant.find(en_pending_participant.id).nurse).not_to be_nil
  end
end
