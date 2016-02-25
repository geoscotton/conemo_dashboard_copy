require "spec_helper"

RSpec.describe NurseDashboardsController, type: :controller do
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

    context "for an authenticated nurse" do
      let(:nurse) { Nurse.find_by(locale: locale) }

      def show_for_nurse
        sign_in_user nurse
        get :show, locale: locale
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
        expect(Participant.where(nurse: nurse).active.count).to be > 0

        show_for_nurse

        expect(assigns(:nurse_dashboard).participants.length)
          .to eq Participant.where(nurse: nurse).active.count
      end
    end
  end
end
