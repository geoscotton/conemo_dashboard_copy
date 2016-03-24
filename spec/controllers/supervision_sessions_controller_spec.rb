# frozen_string_literal: true
require "rails_helper"

RSpec.describe SupervisionSessionsController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:nurse) do
    Nurse.where.not(nurse_supervisor: nil).find_by(locale: locale)
  end
  let(:nurse_supervisor) { nurse.nurse_supervisor }

  shared_examples "a bad request" do
    it do
      expect(response).to redirect_to nurse_supervisor_dashboard_url
    end
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, nurse_id: nurse.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      context "when the Nurse isn't found" do
        before do
          sign_in_user nurse_supervisor

          get :new, nurse_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the supervision_session" do
        sign_in_user nurse_supervisor

        get :new, nurse_id: nurse.id, locale: locale

        expect(assigns(:supervision_session))
          .to be_instance_of SupervisionSession
        expect(assigns(:supervision_session).nurse)
          .to eq nurse
      end
    end
  end

  describe "POST create" do
    let(:valid_params) do
      {
        session_at: Time.zone.now,
        session_length: 20,
        meeting_kind: "Individual",
        contact_kind: "In person"
      }
    end
    let(:invalid_params) do
      { session_at: nil }
    end

    context "for an unauthenticated request" do
      before { post :create, nurse_id: nurse.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      context "when successful" do
        it "creates a new SupervisionSession" do
          sign_in_user nurse_supervisor

          expect do
            post :create, nurse_id: nurse.id,
                          supervision_session: valid_params,
                          locale: locale
          end.to change {
            SupervisionSession.where(nurse: nurse).count
          }.by(1)
        end

        it "redirects to the nurse_tasks_path" do
          sign_in_user nurse_supervisor

          post :create, nurse_id: nurse.id, locale: locale,
                        supervision_session: valid_params

          expect(response).to redirect_to nurse_supervisor_dashboard_url
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          sign_in_user nurse_supervisor

          post :create, nurse_id: nurse.id, locale: locale,
                        supervision_session: invalid_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          sign_in_user nurse_supervisor

          post :create, nurse_id: nurse.id, locale: locale,
                        supervision_session: invalid_params

          expect(response).to render_template :new
        end
      end
    end
  end
end
