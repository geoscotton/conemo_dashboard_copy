require "spec_helper"

RSpec.describe ThirdContactsController, type: :controller do
  describe ".filter_params" do
    it "permits expected parameters" do
      raw_params = {
        third_contact: {
          contact_at: 'a',
          session_length: 'b',
          final_appointment_at: 'c',
          final_appointment_location: 'd',
          q1: 'e',
          q2: 'f',
          q2_notes: 'g',
          q3: 'h',
          q3_notes: 'i',
          q4: 'j',
          q4_notes: 'k',
          q5: 'l',
          q5_notes: 'm',
          notes: 'n',
          patient_contacts_attributes: {
            "0": {
              contact_reason: 'o',
              note: 'p',
              participant_id: 'q'
            }
          },
          nurse_participant_evaluation_attributes: {
            "0": {
              q1: 'r',
              q2: 's'
            }
          }
        }
      }
      params = ActionController::Parameters.new(raw_params)
      filtered_params = ThirdContactsController.filter_params(params)

      expect(filtered_params)
        .to eq(raw_params[:third_contact].with_indifferent_access)
    end
  end
end
