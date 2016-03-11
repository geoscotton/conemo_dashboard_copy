# frozen_string_literal: true
require "rails_helper"

RSpec.describe NonAdherenceCallsController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:participant) do
    Participant.active.where.not(nurse: nil).find_by(locale: locale)
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
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          get :new, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the non_adherence_call" do
        sign_in_user nurse

        get :new, participant_id: participant.id, locale: locale

        expect(assigns(:non_adherence_call))
          .to be_instance_of NonAdherenceCall
        expect(assigns(:non_adherence_call).participant)
          .to eq participant
      end
    end
  end

  describe "POST create" do
    let(:valid_params) do
      { contact_at: Time.zone.now, explanation: "foobar" }
    end
    let(:invalid_params) do
      { contact_at: nil, explanation: nil }
    end

    context "for an unauthenticated request" do
      before { post :create, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      context "when successful" do
        it "creates a new NonAdherenceCall" do
          sign_in_user nurse

          expect do
            post :create, participant_id: participant.id,
                          non_adherence_call: valid_params,
                          locale: locale
          end.to change {
            NonAdherenceCall.where(participant: participant).count
          }.by(1)
        end

        it "redirects to the participant_tasks_path" do
          sign_in_user nurse

          post :create, participant_id: participant.id, locale: locale,
                        non_adherence_call: valid_params

          expect(response).to redirect_to participant_tasks_path(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          sign_in_user nurse

          post :create, participant_id: participant.id, locale: locale,
                        non_adherence_call: invalid_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          sign_in_user nurse

          post :create, participant_id: participant.id, locale: locale,
                        non_adherence_call: invalid_params

          expect(response).to render_template :new
        end
      end
    end
  end
end
