require "spec_helper"

RSpec.describe ThirdContactsController, type: :controller do
  fixtures :all

  def sign_in_admin
    sign_in_user instance_double(User,
                                 nurse?: false,
                                 locale: %w( en pt-BR es-PE ).sample,
                                 timezone: "America/Chicago")
  end

  let(:participant) { Participant.first }

  let(:valid_third_contact_params) do
    {
      contact_at: Time.new,
      session_length: 'b',
      final_appointment_at: Time.new,
      final_appointment_location: 'd',
      q1: 'e',
      q2: false,
      q2_notes: 'g',
      q3: true,
      q3_notes: 'i',
      q4: false,
      q4_notes: 'k',
      q5: true,
      q5_notes: 'm',
      notes: 'n'
    }
  end

  let(:raw_params) do
    valid_third_contact_params.merge(
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
    )
  end

  let(:invalid_third_contact_params) do
    { contact_at: nil, session_length: nil, final_appointment_at: nil }
  end

  shared_examples "a bad request" do
    it { expect(response).to redirect_to active_participants_url }
  end

  describe ".filter_params" do
    it "permits expected parameters" do
      params = ActionController::Parameters.new(third_contact: raw_params)
      filtered_params = ThirdContactsController.filter_params(params)

      expect(filtered_params).to eq raw_params.with_indifferent_access
    end
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_admin

          get :new, participant_id: -1
        end

        it_behaves_like "a bad request"
      end

      it "sets the third_contact" do
        sign_in_admin

        get :new, participant_id: participant.id

        expect(assigns(:third_contact)).to be_instance_of ThirdContact
        expect(assigns(:third_contact).participant).to eq participant
      end

      it "sets the nurse_participant_evaluation" do
        sign_in_admin

        get :new, participant_id: participant.id

        expect(assigns(:nurse_participant_evaluation))
          .to be_instance_of NurseParticipantEvaluation
      end
    end
  end

  describe "POST create" do
    context "for an unauthenticated request" do
      before { post :create, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "when authenticated" do
      context "when the Participant isn't found" do
        before do
          sign_in_admin

          post :create, participant_id: -1
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "redirects to the active participants" do
          user = User.first
          contact = instance_double("ThirdContact",
                                    save: true,
                                    schedule_message: nil)
          sign_in_user user
          allow(Participant).to receive(:find) { participant }

          expect(participant).to receive(:build_third_contact)
            .with(instance_of(ActionController::Parameters))
            .and_return(contact)

          post :create,
               participant_id: participant.id,
               third_contact: { q1: 'question 1' },
               locale: user.locale

          expect(response).to redirect_to(active_participants_path)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          sign_in_admin

          post :create, participant_id: participant.id,
               third_contact: invalid_third_contact_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          sign_in_admin

          post :create, participant_id: participant.id,
               third_contact: invalid_third_contact_params

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

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_admin

          get :edit, participant_id: -1
        end

        it_behaves_like "a bad request"
      end

      it "sets third_contact" do
        sign_in_admin
        participant.create_third_contact(valid_third_contact_params)

        get :edit, participant_id: participant.id

        expect(assigns(:third_contact)).to be_instance_of ThirdContact
        expect(assigns(:third_contact).participant).to eq participant
      end

      it "sets nurse_participant_evaluation" do
        sign_in_admin
        participant.create_third_contact(valid_third_contact_params)

        get :edit, participant_id: participant.id

        expect(assigns(:nurse_participant_evaluation))
          .to be_instance_of NurseParticipantEvaluation
        expect(assigns(:nurse_participant_evaluation).third_contact)
          .to eq participant.third_contact
      end
    end
  end

  describe "PUT update" do
    context "for an unauthenticated request" do
      before { put :update, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_admin

          put :update, participant_id: -1
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "schedules final reminder messages" do
          sign_in_admin
          participant.create_third_contact(valid_third_contact_params)

          expect do
            put :update, participant_id: participant.id,
                third_contact: valid_third_contact_params
          end.to change { ReminderMessage.count }.by(2)
        end

        it "redirects to active_participants_path" do
          sign_in_admin
          participant.create_third_contact(valid_third_contact_params)

          put :update, participant_id: participant.id,
              third_contact: valid_third_contact_params

          expect(response).to redirect_to active_participants_path
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          sign_in_admin
          participant.create_third_contact(valid_third_contact_params)

          put :update, participant_id: participant.id,
              third_contact: invalid_third_contact_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          sign_in_admin
          participant.create_third_contact(valid_third_contact_params)

          put :update, participant_id: participant.id,
              third_contact: invalid_third_contact_params

          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "GET missed_final_appointment" do
    context "for an unauthenticated request" do
      before { get :missed_final_appointment, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_admin

          get :missed_final_appointment, participant_id: -1
        end

        it_behaves_like "a bad request"
      end

      it "sets the third_contact" do
        sign_in_admin
        participant.create_third_contact(valid_third_contact_params)

        get :missed_final_appointment, participant_id: participant.id

        expect(assigns(:third_contact)).to be_instance_of ThirdContact
        expect(assigns(:third_contact).participant).to eq participant
      end

      it "sets the patient_contact" do
        sign_in_admin
        participant.create_third_contact(valid_third_contact_params)

        get :missed_final_appointment, participant_id: participant.id

        expect(assigns(:patient_contact)).to be_instance_of PatientContact
        expect(assigns(:patient_contact).third_contact)
          .to eq participant.third_contact
      end
    end
  end
end
