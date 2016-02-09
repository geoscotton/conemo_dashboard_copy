require "spec_helper"

describe PatientContactsController, type: :controller do
  fixtures :all

  let(:participant) { Participant.first }

  let(:valid_patient_contact_params) { { contact_at: Time.zone.now } }

  shared_examples "a bad request" do
    it { expect(response).to redirect_to active_participants_url }
  end

  def admin_request(http_method, action, params)
    sign_in_admin

    send http_method, action, params
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before { admin_request :get, :new, participant_id: -1 }

        it_behaves_like "a bad request"
      end

      it "sets patient contact" do
        admin_request :get, :new, participant_id: participant.id

        expect(assigns(:patient_contact)).to be_instance_of PatientContact
        expect(assigns(:patient_contact).participant).to eq participant
      end
    end
  end

  describe "POST create" do
    context "for an unauthenticated request" do
      before { post :create, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          admin_request :post, :create, participant_id: -1,
                        patient_contact: valid_patient_contact_params
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "creates a patient contact" do
          expect do
            admin_request :post, :create, participant_id: participant.id,
                          patient_contact: valid_patient_contact_params
          end.to change { PatientContact.where(participant: participant).count }
            .by(1)
        end

        context "and the Participant has a start date" do
          it "redirects to the active report path" do
            participant[:start_date] = Time.zone.today

            admin_request :post, :create, participant_id: participant.id,
                          patient_contact: valid_patient_contact_params

            expect(response).to redirect_to active_report_path(participant)
          end
        end

        context "when the Participant doesn't have a start date" do
          it "redirects to the active participants path" do
            participant.update start_date: nil

            admin_request :post, :create, participant_id: participant.id,
                          patient_contact: valid_patient_contact_params

            expect(response).to redirect_to active_participants_path
          end
        end
      end
    end
  end
  
  describe "DELETE destroy" do
    context "for an unauthenticated request" do
      before { delete :destroy, participant_id: participant.id, id: 1 }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          admin_request :delete, :destroy, participant_id: -1, id: 1
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "destroys a patient contact record" do
          patient_contact = participant.patient_contacts.create(
            valid_patient_contact_params
          )

          expect do
            admin_request(:delete,
                          :destroy,
                          participant_id: participant,
                          id: patient_contact.id)
          end.to change {
            PatientContact.where(participant: participant).count
          }.by(-1)
        end

        context "and the participant has a start date" do
          it "redirects to the active report path" do
            patient_contact = participant.patient_contacts.create(
              valid_patient_contact_params
            )
            participant[:start_date] = Time.zone.today

            admin_request :delete, :destroy, participant_id: participant.id,
                          id: patient_contact.id

            expect(response).to redirect_to active_report_path(participant)
          end
        end

        context "and the participant doesn't have a start date" do
          it "redirects to the active report path" do
            patient_contact = participant.patient_contacts.create(
              valid_patient_contact_params
            )
            participant.update start_date: nil

            admin_request :delete, :destroy, participant_id: participant.id,
                          id: patient_contact.id

            expect(response).to redirect_to active_participants_path
          end
        end

        context "when unsuccessful" do
          it "sets the flash alert" do
            patient_contact = instance_double(PatientContact,
                                              id: 1,
                                              destroy: false)
            allow(PatientContact).to receive(:find) { patient_contact }

            admin_request(:delete,
                          :destroy,
                          participant_id: participant,
                          id: patient_contact.id)

            expect(flash[:alert]).not_to be_nil
          end
        end
      end
    end
  end
end
