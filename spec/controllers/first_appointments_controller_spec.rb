require "spec_helper"

RSpec.describe FirstAppointmentsController, type: :controller do
  fixtures :all

  describe ".filter_params" do
    it "permits expected parameters" do
      # h/t http://blog.pivotal.io/pivotal-labs/labs/rails-4-testing-strong-parameters
      raw_params = {
        first_appointment: {
          appointment_at: 'a',
          appointment_location: 'b',
          next_contact: 'c',
          session_length: 'd',
          notes: 'e',
          smartphone_comfort: 'f',
          smart_phone_comfort_note: 'g',
          participant_session_engagement: 'h',
          app_usage_prediction: 'i',
          patient_contacts_attributes: {
            "0": {
              contact_reason: 'j',
              note: 'k',
              participant_id: 'l'
            }
          }
        }
      }
      params = ActionController::Parameters.new(raw_params)
      filtered_params = FirstAppointmentsController.filter_params(params)

      expect(filtered_params)
        .to eq(raw_params[:first_appointment].with_indifferent_access)
    end
  end
end
