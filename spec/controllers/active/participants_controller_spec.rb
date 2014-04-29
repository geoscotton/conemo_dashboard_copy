require "spec_helper"

module Active
  describe ParticipantsController do
    describe "GET index" do
      context "for authenticated requests" do
        before do
          sign_in_user double("user")
          get :index
        end

        it "should render the index page" do
          expect(response).to render_template :index
        end
      end
    end
  end
end
