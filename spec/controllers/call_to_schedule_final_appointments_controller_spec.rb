# frozen_string_literal: true
require "spec_helper"

RSpec.describe CallToScheduleFinalAppointmentsController, type: :controller do
  fixtures :participants

  let(:locale) { LOCALES.values.sample }
  let(:participant) { Participant.active.find_by(locale: locale) }

  shared_examples "a bad request" do
    it do
      expect(response).to redirect_to active_participants_url(locale: locale)
    end
  end

  def authorize_nurse
    sign_in_nurse locale
    allow(controller).to receive(:authorize!)
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      context "when the Participant isn't found" do
        before do
          authorize_nurse

          get :new, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the call_to_schedule_final_appointment" do
        authorize_nurse

        get :new, participant_id: participant.id, locale: locale

        expect(assigns(:call_to_schedule_final_appointment))
          .to be_instance_of CallToScheduleFinalAppointment
        expect(assigns(:call_to_schedule_final_appointment).participant)
          .to eq participant
      end
    end
  end

  describe "POST create" do
    let(:valid_params) do
      {
        contact_at: Time.zone.now,
        final_appointment_at: Time.zone.now,
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
        it "creates a new FinalAppointment" do
          expect do
            authorize_nurse

            post :create, participant_id: participant.id,
                          call_to_schedule_final_appointment: valid_params,
                          locale: locale
          end.to change {
            CallToScheduleFinalAppointment.where(participant: participant).count
          }.by(1)
        end

        it "redirects to the active_participants_path" do
          authorize_nurse

          post :create, participant_id: participant.id, locale: locale,
                        call_to_schedule_final_appointment: valid_params

          expect(response).to redirect_to active_participants_path
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          authorize_nurse

          post :create, participant_id: participant.id, locale: locale,
                        call_to_schedule_final_appointment: invalid_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          authorize_nurse

          post :create, participant_id: participant.id, locale: locale,
                        call_to_schedule_final_appointment: invalid_params

          expect(response).to render_template :new
        end
      end
    end
  end
end
