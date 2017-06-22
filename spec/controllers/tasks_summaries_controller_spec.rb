# frozen_string_literal: true
require "rails_helper"

RSpec.describe TasksSummariesController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:nurse) { Nurse.find_by(locale: locale) }

  describe "GET show" do
    context "for an unauthenticated request" do
      before { get :show, nurse_id: nurse.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse supervisor" do
      def show_for_nurse
        sign_in_user nurse.nurse_supervisor
        get :show, nurse_id: nurse.id, locale: locale
      end

      context "when the nurse is not found" do
        it "redirects" do
          sign_in_user nurse.nurse_supervisor

          get :show, nurse_id: -1, locale: locale

          expect(response).to redirect_to nurse_supervisor_dashboard_url
        end
      end

      it "renders successfully" do
        show_for_nurse

        expect(response.status).to eq 200
      end

      it "renders the show template" do
        show_for_nurse

        expect(response).to render_template :show
      end

      it "assigns the active participants" do
        # ensure records are populated
        Participant.where(nurse: nurse).first.update status: Participant::ACTIVE

        show_for_nurse

        expect(assigns(:nurse_dashboard).participants.length)
          .to eq Participant.where(nurse: nurse).active.count
      end
    end
  end
end
