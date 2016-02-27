# frozen_string_literal: true
require "rails_helper"

RSpec.describe SecondContactsController, type: :controller do
  fixtures :all

  let(:valid_second_contact_params) do
    { contact_at: Time.zone.now, session_length: 1, next_contact: Time.zone.now }
  end
  let(:invalid_second_contact_params) do
    { contact_at: nil, session_length: nil, next_contact: nil }
  end
  let(:participant) do
    Participant.where.not(nurse: nil).find_by(locale: locale)
  end
  let(:nurse) { participant.nurse }
  let(:locale) { LOCALES.values.sample }

  shared_examples "a bad request" do
    it "should redirect to the nurse dashboard" do
      expect(response).to redirect_to nurse_dashboard_url(nurse)
    end
  end

  describe "GET new" do
    context "for an unauthenticated User" do
      before { get :new, participant_id: participant.id }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          get :new, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the second_contact" do
        admin_request :get, :new, locale, participant_id: participant.id,
                                          locale: locale

        expect(assigns(:second_contact)).to be_instance_of SecondContact
        expect(assigns(:second_contact).participant).to eq participant
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
    context "for an unauthenticated User" do
      before { post :create, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          post :create, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "schedules the third_contact reminder messages" do
          expect do
            admin_request :post, :create, locale,
                          participant_id: participant.id,
                          second_contact: valid_second_contact_params,
                          locale: locale
          end.to change { ReminderMessage.count }.by(3)
        end

        it "redirects to the participant tasks page" do
          admin_request :post, :create, locale,
                        participant_id: participant.id, locale: locale,
                        second_contact: valid_second_contact_params

          expect(response).to redirect_to participant_tasks_url(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :post, :create, locale,
                        participant_id: participant.id, locale: locale,
                        second_contact: invalid_second_contact_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          admin_request :post, :create, locale,
                        participant_id: participant.id, locale: locale,
                        second_contact: invalid_second_contact_params

          expect(response).to render_template :new
        end
      end
    end
  end

  describe "GET edit" do
    context "for an unauthenticated User" do
      before { get :edit, participant_id: participant.id }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          get :edit, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the second_contact" do
        admin_request :get, :edit, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:second_contact)).to eq participant.second_contact
      end

      it "sets the nurse_participant_evaluation" do
        admin_request :get, :edit, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:nurse_participant_evaluation))
          .to be_instance_of NurseParticipantEvaluation
        expect(assigns(:nurse_participant_evaluation).second_contact)
          .to eq participant.second_contact
      end
    end
  end

  describe "PUT update" do
    context "for an unauthenticated User" do
      before { put :update, participant_id: participant.id }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          put :update, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "schedules the third_contact message" do
          participant.create_second_contact(valid_second_contact_params)

          expect do
            admin_request :put, :update, locale,
                          participant_id: participant.id, locale: locale,
                          second_contact: valid_second_contact_params
          end.to change { ReminderMessage.count }.by(3)
        end
      end

      context "when unsuccessful" do
        it "sets the alert" do
          participant.create_second_contact(valid_second_contact_params)

          admin_request :put, :update, locale,
                        participant_id: participant.id, locale: locale,
                        second_contact: invalid_second_contact_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          participant.create_second_contact(valid_second_contact_params)

          admin_request :put, :update, locale,
                        participant_id: participant.id, locale: locale,
                        second_contact: invalid_second_contact_params

          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "GET missed_third_contact" do
    context "for an unauthenticated User" do
      before do
        get :missed_third_contact,
            participant_id: participant.id, locale: locale
      end

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          get :missed_third_contact, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the second_contact" do
        participant.create_second_contact(valid_second_contact_params)

        admin_request :get, :missed_third_contact, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:second_contact)).to eq participant.second_contact
      end

      it "sets the patient_contact" do
        participant.create_second_contact(valid_second_contact_params)

        admin_request :get, :missed_third_contact, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:patient_contact)).to be_instance_of PatientContact
        expect(assigns(:patient_contact).second_contact)
          .to eq participant.second_contact
      end
    end
  end
end
