# frozen_string_literal: true
require "rails_helper"

RSpec.describe FirstContactsController, type: :controller do
  fixtures :users, :participants

  let(:valid_first_contact_params) do
    { contact_at: Time.zone.now, first_appointment_at: Time.zone.now }
  end
  let(:invalid_first_contact_params) do
    { contact_at: nil, first_appointment_at: nil }
  end
  let(:locale) { LOCALES.values.sample }
  let(:participant) do
    Participant.where.not(nurse: nil).active.find_by(locale: locale)
  end
  let(:nurse) { participant.nurse }

  shared_examples "a bad request" do
    it "should redirect to the nurse dashboard" do
      expect(response).to redirect_to nurse_dashboard_url(nurse)
    end
  end

  describe "GET new" do
    context "for an unauthenticated User" do
      before { get :new, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          get :new, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the first_contact" do
        admin_request :get, :new, locale, participant_id: participant.id,
                                          locale: locale

        expect(assigns(:first_contact)).to be_instance_of FirstContact
        expect(assigns(:first_contact).participant).to eq participant
      end
    end
  end

  describe "POST create" do
    context "for an unauthenticated User" do
      before { post :create, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
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
        it "redirects to the participant tasks" do
          admin_request :post, :create, locale,
                        participant_id: participant.id,
                        first_contact: valid_first_contact_params,
                        locale: locale

          expect(response).to redirect_to participant_tasks_url(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :post, :create, locale, participant_id: participant.id,
                                                first_contact: invalid_first_contact_params,
                                                locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          admin_request :post, :create, locale, participant_id: participant.id,
                                                first_contact: invalid_first_contact_params,
                                                locale: locale

          expect(response).to render_template :new
        end
      end
    end
  end

  describe "GET edit" do
    context "for an unauthenticated User" do
      before { get :edit, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          get :edit, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the first_contact" do
        admin_request :get, :edit, locale, participant_id: participant.id,
                                           locale: locale

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
        before do
          sign_in_user nurse

          put :update, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when unsuccessful" do
        it "sets the alert" do
          participant.create_first_contact(valid_first_contact_params)

          admin_request :put, :update, locale, participant_id: participant.id,
                                               first_contact: invalid_first_contact_params,
                                               locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          participant.create_first_contact(valid_first_contact_params)

          admin_request :put, :update, locale, participant_id: participant.id,
                                               first_contact: invalid_first_contact_params,
                                               locale: locale

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
        before do
          sign_in_user nurse

          get :missed_appointment, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the first_contact" do
        participant.create_first_contact(valid_first_contact_params)

        admin_request :get, :missed_appointment, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:first_contact)).to eq participant.first_contact
      end

      it "sets the patient_contact" do
        participant.create_first_contact(valid_first_contact_params)

        admin_request :get, :missed_appointment, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:patient_contact)).to be_instance_of PatientContact
        expect(assigns(:patient_contact).first_contact)
          .to eq participant.first_contact
      end
    end
  end
end
