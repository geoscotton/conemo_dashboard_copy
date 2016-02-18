require "spec_helper"

RSpec.describe FirstAppointmentsController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:participant) { Participant.find_by(locale: locale) }

  let!(:first_appointment) do
    participant.create_first_appointment!(
      appointment_at: Time.zone.now, session_length: 5, next_contact: Time.zone.now
    )
  end

  let(:valid_first_appointment_params) do
    { appointment_at: Time.zone.now, session_length: 1, next_contact: Time.zone.now }
  end

  let(:invalid_first_appointment_params) do
    { appointment_at: nil, session_length: nil, next_contact: nil }
  end

  shared_examples "a bad request" do
    it { expect(response).to redirect_to active_participants_url }
  end

  describe ".filter_params" do
    it "permits expected parameters" do
      # h/t http://blog.pivotal.io/pivotal-labs/labs/rails-4-testing-strong-parameters
      raw_params = {
        first_appointment: {
          appointment_at: "a",
          appointment_location: "b",
          next_contact: "c",
          session_length: "d",
          notes: "e",
          smartphone_comfort: "f",
          smart_phone_comfort_note: "g",
          participant_session_engagement: "h",
          app_usage_prediction: "i",
          patient_contacts_attributes: {
            "0": {
              contact_reason: "j",
              note: "k"
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

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          admin_request :get, :new, locale, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the first appointment" do
        admin_request :get, :new, locale, participant_id: participant.id,
                      locale: locale

        expect(assigns(:first_appointment)).to be_instance_of FirstAppointment
        expect(assigns(:first_appointment).participant).to eq participant
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
          admin_request :post, :create, locale, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "creates a FirstAppointment" do
          FirstAppointment.destroy_all

          expect do
            admin_request :post, :create, locale, participant_id: participant.id,
                          first_appointment: valid_first_appointment_params,
                          locale: locale
          end.to change {
            FirstAppointment.where(participant: participant).count
          }.by(1)
        end

        it "schedules messages" do
          expect do
            admin_request :post, :create, locale, participant_id: participant.id,
                          first_appointment: valid_first_appointment_params,
                          locale: locale
          end.to change { ReminderMessage.count }.by(3)
        end

        it "redirects to new participant smartphone" do
          admin_request :post, :create, locale, participant_id: participant.id,
                        first_appointment: valid_first_appointment_params,
                        locale: locale

          expect(response).to redirect_to new_participant_smartphone_path
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :post, :create, locale, participant_id: participant.id,
                        first_appointment: invalid_first_appointment_params,
                        locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          admin_request :post, :create, locale, participant_id: participant.id,
                        first_appointment: invalid_first_appointment_params,
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

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          admin_request :get, :edit, locale, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the first appointment" do
        participant.create_first_appointment valid_first_appointment_params

        admin_request :get, :edit, locale, participant_id: participant.id,
                      locale: locale

        expect(assigns(:first_appointment)).to eq participant.first_appointment
      end
    end
  end

  describe "GET missed_second_contact" do
    context "for an unauthenticated request" do
      before { get :missed_second_contact, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          admin_request :get, :missed_second_contact, locale, participant_id: -1,
                        locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the first appointment" do
        admin_request :get, :missed_second_contact, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:first_appointment)).to eq participant.first_appointment
      end

      it "sets the patient contact" do
        admin_request :get, :missed_second_contact, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:patient_contact)).to be_instance_of PatientContact
        expect(assigns(:patient_contact).first_appointment)
          .to eq participant.first_appointment
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
          admin_request :put, :update, locale, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "updates the FirstAppointment" do
          expect do
            admin_request :put, :update, locale, participant_id: participant.id,
                          first_appointment: valid_first_appointment_params,
                          locale: locale
          end.to change {
            FirstAppointment.find_by(participant_id: participant.id).updated_at
          }
        end

        it "schedules messages" do
          expect do
            admin_request :put, :update, locale, participant_id: participant.id,
                          first_appointment: valid_first_appointment_params,
                          locale: locale
          end.to change { ReminderMessage.count }.by(3)
        end

        it "redirects to active participants" do
          admin_request :put, :update, locale, participant_id: participant.id,
                        first_appointment: valid_first_appointment_params,
                        locale: locale

          expect(response).to redirect_to active_participants_path
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :put, :update, locale, participant_id: participant.id,
                        first_appointment: invalid_first_appointment_params,
                        locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          admin_request :put, :update, locale, participant_id: participant.id,
                        first_appointment: invalid_first_appointment_params,
                        locale: locale

          expect(response).to render_template :edit
        end
      end
    end
  end
end
