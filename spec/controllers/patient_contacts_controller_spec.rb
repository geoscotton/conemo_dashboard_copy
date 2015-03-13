require "spec_helper"

describe PatientContactsController do
  fixtures(
    :users, :participants, :patient_contacts
  )
  
  describe "DELETE destroy" do
    let(:user) { double("user", admin?: true, nurse?: false, timezone: "Central Time (US & Canada)") }

    let!(:patient_contact) { patient_contacts(:patient_contact1) }
    let!(:participant) { participants(:participant1) }
    
    before do
      sign_in_user user
    end

    it "should destroy a patient contact record" do
      expect{
        delete :destroy, participant_id: participant, id: patient_contact
      }.to change(PatientContact, :count).by(-1)
    end
  end
end
