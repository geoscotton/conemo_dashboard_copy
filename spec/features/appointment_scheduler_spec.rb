require "spec_helper"

describe "appointment scheduler", type: :feature do
  fixtures :all

  before(:each) do
    sign_in_user users(:nurse1)
  end

  let(:participant) { participants(:active_participant) }

  describe "first appointment time and place" do
    let!(:first_contact) { first_contacts(:english_first_contact)}

    context "first contact already created" do
      it "displays first appointment info on index page" do
        visit "/en/active/participants"
        expect(page).to have_text participant.first_contact.first_appointment_at.in_time_zone(participant.nurse.timezone).to_s(:short)
        expect(page).to have_text participant.first_contact.first_appointment_location
      end
    end
  end
end
