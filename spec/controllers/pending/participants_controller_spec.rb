require "spec_helper"

module Pending
  describe ParticipantsController do
    let(:user) { double("user", admin?: true, nurse?: false, timezone: "Central Time (US & Canada)") }
    describe "GET index" do
      context "for authenticated requests" do
        before do
          sign_in_user user
          get :index
        end

        it "should render the index page" do
          expect(response).to render_template :index
        end
      end
    end

    describe "GET activate" do
      context "for unauthenticated requests" do
        before { get :activate, id: 1 }
        it_behaves_like "a rejected user action"
      end

      context "for authenticated requests" do
        context "when the participant is found" do
          before do
            allow(Participant).to receive_message_chain("find")
              .and_return([double("participant")])
            sign_in_user user
            get :activate, id: 1
          end

          it "should render the activate page" do
            expect(response).to render_template :activate
          end
        end

        context "when the participant is not found" do
          before do
            allow(Participant).to receive_message_chain("pending.find")
              .and_raise(ActiveRecord::RecordNotFound)
            sign_in_user user
            get :activate, id: 1
          end

          it "should redirect to the index page" do
            expect(response).to redirect_to pending_participants_url
          end
        end
      end
    end
  end
end
