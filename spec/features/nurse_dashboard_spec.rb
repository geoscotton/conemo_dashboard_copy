# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Nurse dashboard", type: :feature do
  fixtures :users, :participants

  let(:es_nurse) { users(:peruvian_nurse) }

  scenario "a Nurse creates an additional contact" do
    sign_in_user es_nurse

    visit "/es-PE/participants/#{es_nurse.active_participants.first.id}/tasks"
    click_on "Additional contact"

    select Time.zone.today.year, from: "additional_contact_scheduled_at_1i"
    select "febrero", from: "additional_contact_scheduled_at_2i"
    select "1", from: "additional_contact_scheduled_at_3i"
    select "10", from: "additional_contact_scheduled_at_4i"
    select "10", from: "additional_contact_scheduled_at_5i"

    select "En persona", from: "Tipo de contacto"

    click_on "Guardar"

    expect(page).to have_content "Additional contact saved successfully"
  end
end
