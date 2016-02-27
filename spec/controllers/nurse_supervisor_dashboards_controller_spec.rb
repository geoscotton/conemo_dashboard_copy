# frozen_string_literal: true
require "rails_helper"

RSpec.describe NurseSupervisorDashboardsController, type: :controller do
  fixtures :users, :participants

  let(:locale) { LOCALES.values.sample }

  describe "GET show" do
    context "for an unauthenticated request" do
      before { get :show }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      before do
        nurse_request :get, :show, locale
      end

      it_behaves_like "an unauthorized user action" do
        let(:user_locale) { locale }
      end
    end

    context "for an authenticated nurse supervisor" do
      def show_for_nurse_supervisor
        sign_in_user NurseSupervisor.find_by(locale: locale)
        get :show, locale: locale
      end

      it "renders successfully" do
        show_for_nurse_supervisor

        expect(response.status).to eq 200
      end

      it "renders the show template" do
        show_for_nurse_supervisor

        expect(response).to render_template :show
      end

      it "assigns the pending participants" do
        # ensure records are populated
        expect(Participant.where(locale: locale).pending.count).to be > 0

        show_for_nurse_supervisor

        expect(assigns(:pending_participants).length)
          .to eq Participant.where(locale: locale).pending.count
      end
    end
  end
end
