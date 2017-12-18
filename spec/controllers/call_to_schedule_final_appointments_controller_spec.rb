# frozen_string_literal: true
require "rails_helper"

RSpec.describe CallToScheduleFinalAppointmentsController, type: :controller do
  fixtures :all

  let(:now) { Time.zone.now }
  let(:valid_params) do
    {
      contact_at: now,
      final_appointment_at: now,
      final_appointment_location: "l"
    }
  end
  let(:invalid_params) do
    {
      contact_at: nil,
      final_appointment_at: nil,
      final_appointment_location: nil
    }
  end
  let(:locale) { LOCALES.values.sample }
  let(:participant) do
    Participant.where.not(nurse: nil).active.find_by(locale: locale)
  end
  let(:nurse) { participant.nurse }

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

    context "for an authenticated nurse" do
      before do
        sign_in_user nurse
      end

      context "when the Participant isn't found" do
        before do
          get :new, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the call_to_schedule_final_appointment" do
        get :new, participant_id: participant.id, locale: locale

        expect(assigns(:call_to_schedule_final_appointment))
          .to be_instance_of CallToScheduleFinalAppointment
        expect(assigns(:call_to_schedule_final_appointment).participant)
          .to eq participant
      end

      it "sets an existing appointment" do
        appointment =
          participant.create_call_to_schedule_final_appointment(valid_params)

        get :new, participant_id: participant.id, locale: locale

        expect(assigns(:call_to_schedule_final_appointment)).to eq appointment
      end
    end
  end

  describe "POST create" do
    let(:valid_params) do
      {
        contact_at: now,
        final_appointment_at: now,
        final_appointment_location: "l"
      }
    end
    let(:invalid_params) do
      {
        contact_at: nil,
        final_appointment_at: nil,
        final_appointment_location: nil
      }
    end

    context "for an unauthenticated request" do
      before { post :create, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      context "when successful" do
        it "creates a new CallToScheduleFinalAppointment" do
          expect do
            sign_in_user nurse

            post :create, participant_id: participant.id,
                          call_to_schedule_final_appointment: valid_params,
                          locale: locale
          end.to change {
            CallToScheduleFinalAppointment.where(participant: participant).count
          }.by(1)
        end

        it "redirects to the participant tasks" do
          sign_in_user nurse

          post :create, participant_id: participant.id, locale: locale,
                        call_to_schedule_final_appointment: valid_params

          expect(response).to redirect_to participant_tasks_url(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          sign_in_user nurse

          post :create, participant_id: participant.id, locale: locale,
                        call_to_schedule_final_appointment: invalid_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          sign_in_user nurse

          post :create, participant_id: participant.id, locale: locale,
                        call_to_schedule_final_appointment: invalid_params

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

      it "sets the call_to_schedule_final_appointment" do
        admin_request :get, :edit, locale, participant_id: participant.id,
                                           locale: locale

        expect(assigns(:call_to_schedule_final_appointment))
          .to eq participant.call_to_schedule_final_appointment
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

      context "when successful" do
        it "redirects to the active participant page" do
          participant.create_call_to_schedule_final_appointment(valid_params)
          sign_in_user nurse

          put :update, participant_id: participant.id, locale: locale,
                       call_to_schedule_final_appointment: valid_params

          expect(response)
            .to redirect_to active_participant_url(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the alert" do
          participant.create_call_to_schedule_final_appointment(valid_params)
          sign_in_user nurse

          put :update, participant_id: participant.id, locale: locale,
                       call_to_schedule_final_appointment: invalid_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          participant.create_call_to_schedule_final_appointment(valid_params)
          sign_in_user nurse

          put :update, participant_id: participant.id, locale: locale,
                       call_to_schedule_final_appointment: invalid_params

          expect(response).to render_template :edit
        end
      end
    end
  end
end
