require "spec_helper"

RSpec.describe FinalAppointmentsController, type: :controller do
  fixtures :all

  let(:participant) { Participant.first }

  let(:valid_final_appointment_params) do
    {
      appointment_at: Time.zone.now,
      appointment_location: "l",
      phone_returned: true
    }
  end

  let(:invalid_final_appointment_params) do
    { appointment_at: nil, appointment_location: nil, phone_returned: nil }
  end

  shared_examples "a bad request" do
    it { expect(response).to redirect_to active_participants_url }
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id }
      
      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          sign_in_admin

          get :new, participant_id: -1
        end

        it_behaves_like "a bad request"
      end

      it "sets the final_appointment" do
        sign_in_admin

        get :new, participant_id: participant.id

        expect(assigns(:final_appointment)).to be_instance_of FinalAppointment
        expect(assigns(:final_appointment).participant).to eq participant
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
          sign_in_admin

          post :create, participant_id: -1
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "creates a new FinalAppointment" do
          sign_in_admin

          expect do
            post :create, participant_id: participant.id,
                 final_appointment: valid_final_appointment_params
          end.to change {
            FinalAppointment.where(participant: participant).count
          }.by(1)
        end

        it "redirects to the active_participants_path" do
          sign_in_admin

          post :create, participant_id: participant.id,
               final_appointment: valid_final_appointment_params

          expect(response).to redirect_to active_participants_path
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          sign_in_admin

          post :create, participant_id: participant.id,
               final_appointment: invalid_final_appointment_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          sign_in_admin

          post :create, participant_id: participant.id,
               final_appointment: invalid_final_appointment_params

          expect(response).to render_template :new
        end
      end
    end
  end

  describe "GET edit" do
    context "for an unauthenticated request" do
      before { get :edit, participant_id: participant.id }
      
      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          sign_in_admin

          get :edit, participant_id: -1
        end

        it_behaves_like "a bad request"
      end

      it "sets the final_appointment" do
        sign_in_admin
        participant.create_final_appointment valid_final_appointment_params

        get :edit, participant_id: participant.id

        expect(assigns(:final_appointment)).to be_instance_of FinalAppointment
        expect(assigns(:final_appointment).participant).to eq participant
      end
    end
  end

  describe "PUT update" do
    context "for an unauthenticated request" do
      before { put :update, participant_id: participant.id }
      
      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          sign_in_admin

          put :update, participant_id: -1
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "redirects to the active_participants_path" do
          sign_in_admin
          participant.create_final_appointment valid_final_appointment_params

          put :update, participant_id: participant.id,
              final_appointment: valid_final_appointment_params

          expect(response).to redirect_to active_participants_path
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          sign_in_admin
          participant.create_final_appointment valid_final_appointment_params

          put :update, participant_id: participant.id,
              final_appointment: invalid_final_appointment_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          sign_in_admin
          participant.create_final_appointment valid_final_appointment_params

          put :update, participant_id: participant.id,
              final_appointment: invalid_final_appointment_params

          expect(response).to render_template :edit
        end
      end
    end
  end
end
