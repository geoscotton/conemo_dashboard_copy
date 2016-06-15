# frozen_string_literal: true
require "rails_helper"

RSpec.describe DashboardsController, type: :controller do
  fixtures :all

  describe "GET index" do
    context "when a Nurse accesses it" do
      it "redirects to the nurse dashboard" do
        nurse = Nurse.all.sample
        sign_in_user nurse

        get :index, locale: nurse.locale

        expect(response).to redirect_to nurse_dashboard_url
      end
    end

    context "when a Nurse Supervisor accesses it" do
      it "redirects to the nurse supervisor dashboard" do
        supervisor = NurseSupervisor.all.sample
        sign_in_user supervisor

        get :index, locale: supervisor.locale

        expect(response).to redirect_to nurse_supervisor_dashboard_url
      end
    end

    context "when an Admin accesses it" do
      it "redirects to the pending participants page" do
        admin = Admin.all.sample
        sign_in_user admin

        get :index, locale: admin.locale

        expect(response).to redirect_to pending_participants_url
      end
    end

    context "when a Superuser accesses it" do
      it "redirects to Rails admin" do
        user = Superuser.all.sample
        sign_in_user user

        get :index, locale: user.locale

        expect(response).to redirect_to rails_admin_url
      end
    end

    context "when a Statistician accesses it" do
      it "redirects to Rails admin" do
        user = Statistician.all.sample
        sign_in_user user

        get :index, locale: user.locale

        expect(response).to redirect_to rails_admin_url
      end
    end
  end
end
