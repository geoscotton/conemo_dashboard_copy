require "spec_helper"

describe "appointment scheduler" do
  fixtures(
    :users, :participants, :first_contacts, :first_appointments
  )

  before(:each) do
    sign_in_user users(:admin1)
  end

  let(:participant) { participants(:active_participant) }

  describe "first appointment time and place" do
    let!(:first_contact) { first_contacts(:english_first_contact)}

    context "first contact already created" do
      it "displays first appointment info on index page" do
        visit "/en/active/participants"
        expect(page).to have_text participant.first_contact.first_appointment_at.to_s(:short)
        expect(page).to have_text participant.first_contact.first_appointment_location
      end
    end
  end
end