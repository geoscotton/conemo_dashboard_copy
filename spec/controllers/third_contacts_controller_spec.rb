require "spec_helper"

RSpec.describe ThirdContactsController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:participant) { Participant.find_by(locale: locale) }
  let(:valid_third_contact_params) do
    {
      contact_at: Time.zone.now,
      session_length: "b",
      call_to_schedule_final_appointment_at: Time.zone.now,
      q1: "e",
      q2: false,
      q2_notes: "g",
      q3: true,
      q3_notes: "i",
      q4: false,
      q4_notes: "k",
      q5: true,
      q5_notes: "m",
      notes: "n"
    }
  end
  let(:raw_params) do
    valid_third_contact_params.merge(
      patient_contacts_attributes: {
        "0": {
          contact_reason: "o",
          note: "p"
        }
      },
      nurse_participant_evaluation_attributes: {
        "0": {
          q1: "r",
          q2: "s"
        }
      }
    )
  end
  let(:invalid_third_contact_params) do
    {
      contact_at: nil,
      session_length: nil,
      call_to_schedule_final_appointment_at: nil
    }
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
      before { get :new, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          admin_request :get, :new, locale, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the third_contact" do
        admin_request :get, :new, locale, participant_id: participant.id, locale: locale

        expect(assigns(:third_contact)).to be_instance_of ThirdContact
        expect(assigns(:third_contact).participant).to eq participant
      end

      it "sets the nurse_participant_evaluation" do
        admin_request :get, :new, locale, participant_id: participant.id,
                      locale: locale

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
          admin_request :post, :create, locale, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "redirects to the active participants" do
          contact = instance_double("ThirdContact",
                                    save: true,
                                    schedule_message: nil)
          allow(Participant).to receive(:find) { participant }

          expect(participant).to receive(:build_third_contact)
            .with(instance_of(ActionController::Parameters))
            .and_return(contact)

          admin_request :post, :create, locale,
                        participant_id: participant.id,
                        third_contact: { q1: "question 1" },
                        locale: locale

          expect(response)
            .to redirect_to(active_participants_path(locale: locale))
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :post, :create, locale, participant_id: participant.id,
                        third_contact: invalid_third_contact_params,
                        locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          admin_request :post, :create, locale, participant_id: participant.id,
                        third_contact: invalid_third_contact_params,
                        locale: locale

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
          admin_request :get, :edit, locale, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets third_contact" do
        participant.create_third_contact(valid_third_contact_params)

        admin_request :get, :edit, locale, participant_id: participant.id,
                      locale: locale

        expect(assigns(:third_contact)).to be_instance_of ThirdContact
        expect(assigns(:third_contact).participant).to eq participant
      end

      it "sets nurse_participant_evaluation" do
        participant.create_third_contact(valid_third_contact_params)

        admin_request :get, :edit, locale, participant_id: participant.id,
                      locale: locale

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
          admin_request :put, :update, locale, participant_id: -1,
                        locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "schedules final reminder messages" do
          participant.create_third_contact(valid_third_contact_params)

          expect do
            admin_request :put, :update, locale, participant_id: participant.id,
                          third_contact: valid_third_contact_params,
                          locale: locale
          end.to change { ReminderMessage.count }.by(4)
        end

        it "redirects to active_participants_path" do
          participant.create_third_contact(valid_third_contact_params)

          admin_request :put, :update, locale, participant_id: participant.id,
                        third_contact: valid_third_contact_params,
                        locale: locale

          expect(response).to redirect_to active_participants_path
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          participant.create_third_contact(valid_third_contact_params)

          admin_request :put, :update, locale, participant_id: participant.id,
                        third_contact: invalid_third_contact_params,
                        locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          participant.create_third_contact(valid_third_contact_params)

          admin_request :put, :update, locale, participant_id: participant.id,
                        third_contact: invalid_third_contact_params,
                        locale: locale

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
          admin_request :get, :missed_final_appointment, locale,
                        participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the third_contact" do
        participant.create_third_contact(valid_third_contact_params)

        admin_request :get, :missed_final_appointment, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:third_contact)).to be_instance_of ThirdContact
        expect(assigns(:third_contact).participant).to eq participant
      end

      it "sets the patient_contact" do
        participant.create_third_contact(valid_third_contact_params)

        admin_request :get, :missed_final_appointment, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:patient_contact)).to be_instance_of PatientContact
        expect(assigns(:patient_contact).third_contact)
          .to eq participant.third_contact
      end
    end
  end
end
