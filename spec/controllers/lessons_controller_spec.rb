require "spec_helper"

describe LessonsController do
  let(:user) { double("user", admin?: true, nurse?: false, timezone: "Central Time (US & Canada)") }
  let(:lesson) { double("lesson") }

  shared_context "lesson is found" do
    before { allow(Lesson).to receive_message_chain("where.find") { lesson } }
  end

  describe "GET index" do
    context "for unauthenticated requests" do
      before { get :index }
      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      before do
        sign_in_user user
        get :index
      end

      it { expect(response).to render_template :index }
    end
  end

  describe "GET show" do
    context "for unauthenticated requests" do
      before { get :show, id: 1 }
      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      before { sign_in_user user }

      context "when the lesson is found" do
        include_context "lesson is found"
        before { get :show, id: 1 }
        it { expect(response).to render_template :show }
      end

      context "when the lesson is not found" do
      end
    end
  end

  describe "GET new" do
    context "for unauthenticated requests" do
      before { get :new }
      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      before do
        sign_in_user user
      end
    end
  end

  describe "POST update" do
    context "for unauthenticated requests" do
      before { post :update, id: 1 }
      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      before do
        sign_in_user user
      end
    end
  end

  describe "GET edit" do
    context "for unauthenticated requests" do
      before { get :edit, id: 1 }
      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      before do
        sign_in_user user
      end
    end
  end

  describe "PUT update" do
    context "for unauthenticated requests" do
      before { put :update, id: 1 }
      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      before do
        sign_in_user user
      end
    end
  end

  describe "DELETE destroy" do
    context "for unauthenticated requests" do
      before { delete :destroy, id: 1 }
      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      before do
        sign_in_user user
      end
    end
  end
end
