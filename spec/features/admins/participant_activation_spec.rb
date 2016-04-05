# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Participant activation", type: :feature do
  fixtures :all

  let(:en_admin) { users(:admin1) }
  let(:en_unassigned_participant) { participants(:en_unassigned_participant) }

  scenario "an Admin activates a Participant" do
    expect(en_unassigned_participant.nurse).to be_nil
    sign_in_user en_admin
    visit "/en/pending/participants"

    expect do
      within "#participant-#{en_unassigned_participant.id}" do
        click_on "Activate"
      end
    end.to change { Participant.pending.count }.by(1)
  end
end
