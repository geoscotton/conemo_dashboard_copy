require "spec_helper"

RSpec.describe ThirdContactsController, type: :controller do
  fixtures :all

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

  describe "POST create" do
    context "when unauthenticated" do
      it "redirect to the login page" do
        post :create, participant_id: Participant.first.id

        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when authenticated" do
      context "and the contact saves successfully" do
        it "redirects to the active participants" do
          user = User.first
          participant = instance_double("Participant")
          contact = instance_double("ThirdContact",
                                    save: true,
                                    schedule_message: nil)
          sign_in_user user
          allow(Participant).to receive(:find) { participant }

          expect(participant).to receive(:build_third_contact)
            .with(instance_of(ActionController::Parameters))
            .and_return(contact)

          post :create,
               participant_id: Participant.first.id,
               third_contact: { q1: 'question 1' },
               locale: user.locale

          expect(response).to redirect_to(active_participants_path)
        end
      end
    end
  end
end
