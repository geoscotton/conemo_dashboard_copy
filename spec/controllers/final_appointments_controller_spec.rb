# frozen_string_literal: true
require "rails_helper"

RSpec.describe FinalAppointmentsController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:participant) { Participant.where.not(nurse: nil).find_by(locale: locale) }
  let(:nurse) { participant.nurse }
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
    it do
      expect(response).to redirect_to nurse_dashboard_url(nurse)
    end
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          get :new, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the final_appointment" do
        nurse_request :get, :new, locale, participant_id: participant.id,
                                          locale: locale

        expect(assigns(:final_appointment)).to be_instance_of FinalAppointment
        expect(assigns(:final_appointment).participant).to eq participant
      end
    end
  end

  describe "POST create" do
    context "for an unauthenticated request" do
      before { post :create, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          post :create, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "creates a new FinalAppointment" do
          expect do
            admin_request :post, :create, locale,
                          participant_id: participant.id,
                          final_appointment: valid_final_appointment_params,
                          locale: locale
          end.to change {
            FinalAppointment.where(participant: participant).count
          }.by(1)
        end

        it "redirects to the participant tasks page" do
          admin_request :post, :create, locale,
                        participant_id: participant.id,
                        final_appointment: valid_final_appointment_params,
                        locale: locale

          expect(response).to redirect_to participant_tasks_url(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :post, :create, locale,
                        participant_id: participant.id,
                        final_appointment: invalid_final_appointment_params,
                        locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          admin_request :post, :create, locale,
                        participant_id: participant.id,
                        final_appointment: invalid_final_appointment_params,
                        locale: locale

          expect(response).to render_template :new
        end
      end
    end
  end

  describe "GET edit" do
    context "for an unauthenticated request" do
      before { get :edit, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          get :edit, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the final_appointment" do
        participant.create_final_appointment valid_final_appointment_params

        admin_request :get, :edit, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:final_appointment)).to be_instance_of FinalAppointment
        expect(assigns(:final_appointment).participant).to eq participant
      end
    end
  end

  describe "PUT update" do
    context "for an unauthenticated request" do
      before { put :update, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          put :update, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "redirects to the active participant page" do
          participant.create_final_appointment valid_final_appointment_params

          admin_request :put, :update, locale,
                        participant_id: participant.id,
                        final_appointment: valid_final_appointment_params,
                        locale: locale

          expect(response).to redirect_to active_participant_url(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          participant.create_final_appointment valid_final_appointment_params

          admin_request :put, :update, locale,
                        participant_id: participant.id, locale: locale,
                        final_appointment: invalid_final_appointment_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          participant.create_final_appointment valid_final_appointment_params

          admin_request :put, :update, locale,
                        participant_id: participant.id, locale: locale,
                        final_appointment: invalid_final_appointment_params

          expect(response).to render_template :edit
        end
      end
    end
  end
end
