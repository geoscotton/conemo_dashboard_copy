require "spec_helper"

RSpec.describe FirstContactsController, type: :controller do
  fixtures :all

  let(:valid_first_contact_params) do
    { contact_at: Time.new, first_appointment_at: Time.new }
  end

  let(:invalid_first_contact_params) do
    { contact_at: nil, first_appointment_at: nil }
  end

  let(:participant) { Participant.first }

  shared_examples "a bad request" do
    it "should redirect to the active_participants_url" do
      expect(response).to redirect_to active_participants_url
    end
  end

  describe "GET new" do
    context "for an unauthenticated User" do
      before { get :new, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before { admin_request :get, :new, participant_id: -1 }

        it_behaves_like "a bad request"
      end

      it "sets the first_contact" do
        admin_request :get, :new, participant_id: participant.id

        expect(assigns(:first_contact)).to be_instance_of FirstContact
        expect(assigns(:first_contact).participant).to eq participant
      end
    end
  end

  describe "POST create" do
    context "for an unauthenticated User" do
      before { post :create, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before { admin_request :post, :create, participant_id: -1 }

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "schedules the third_contact reminder messages" do
          expect do
            admin_request :post, :create, participant_id: participant.id,
                 first_contact: valid_first_contact_params
          end.to change { ReminderMessage.count }.by(4)
        end

        it "redirects to the active_participants_path" do
          admin_request :post, :create, participant_id: participant.id,
                        first_contact: valid_first_contact_params

          expect(response).to redirect_to active_participants_path
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :post, :create, participant_id: participant.id,
                        first_contact: invalid_first_contact_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          admin_request :post, :create, participant_id: participant.id,
                        first_contact: invalid_first_contact_params

          expect(response).to render_template :new
        end
      end
    end
  end

  describe "GET edit" do
    context "for an unauthenticated User" do
      before { get :edit, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before { admin_request :get, :edit, participant_id: -1 }

        it_behaves_like "a bad request"
      end

      it "sets the first_contact" do
        admin_request :get, :edit, participant_id: participant.id

        expect(assigns(:first_contact)).to eq participant.first_contact
      end
    end
  end

  describe "PUT update" do
    context "for an unauthenticated User" do
      before { put :update, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before { admin_request :put, :update, participant_id: -1 }

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "schedules the third_contact message" do
          participant.create_first_contact(valid_first_contact_params)

          expect do
            admin_request :put, :update, participant_id: participant.id,
                          first_contact: valid_first_contact_params
          end.to change { ReminderMessage.count }.by(4)
        end
      end
      
      context "when unsuccessful" do
        it "sets the alert" do
          participant.create_first_contact(valid_first_contact_params)

          admin_request :put, :update, participant_id: participant.id,
                        first_contact: invalid_first_contact_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          participant.create_first_contact(valid_first_contact_params)

          admin_request :put, :update, participant_id: participant.id,
                        first_contact: invalid_first_contact_params

          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "GET missed_appointment" do
    context "for an unauthenticated User" do
      before { get :missed_appointment, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before { admin_request :get, :missed_appointment, participant_id: -1 }

        it_behaves_like "a bad request"
      end

      it "sets the first_contact" do
        participant.create_first_contact(valid_first_contact_params)

        admin_request :get, :missed_appointment, participant_id: participant.id

        expect(assigns(:first_contact)).to eq participant.first_contact
      end

      it "sets the patient_contact" do
        participant.create_first_contact(valid_first_contact_params)

        admin_request :get, :missed_appointment, participant_id: participant.id

        expect(assigns(:patient_contact)).to be_instance_of PatientContact
        expect(assigns(:patient_contact).first_contact)
          .to eq participant.first_contact
      end
    end
  end
end