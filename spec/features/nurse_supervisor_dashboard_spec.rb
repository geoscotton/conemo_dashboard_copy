# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Nurse supervisor dashboard", type: :feature do
  fixtures :all

  let(:es_nurse_supervisor) { users(:peruvian_nurse_supervisor_1) }

  scenario "a Nurse Supervisor activates a participant" do
    sign_in_user es_nurse_supervisor

    click_on "Activar Participante"

    expect(page).to have_content "Asignar enfermero para activar"

    click_on "Guardar"

    expect(page).to have_content "Información actualizada satisfactoriamente"
  end
end
