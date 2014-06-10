require "spec_helper"

module Active
  describe ParticipantsController do
    describe "GET index" do
      let(:user) { double("user", admin?: true, nurse?: false) }
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
  end
end
