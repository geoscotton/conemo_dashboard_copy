# frozen_string_literal: true
require "rails_helper"

RSpec.describe SupervisorNotificationsController, type: :controller do
  fixtures :all

  describe "PUT clear" do
    let(:notification) { supervisor_notifications(:first_notification) }

    let(:nurse) { notification.nurse_task.nurse }

    def authorize!
      allow(controller).to receive(:authorize!)
    end

    context "for unauthenticated requests" do
      before { put :clear, nurse_id: nurse.id }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by nurse supervisors" do
      it "resolves a notification from a nurse" do
        expect(notification.status).not_to eq "resolved"

        authorize!

        sign_in_user nurse.nurse_supervisor
        put :clear, nurse_id: nurse.id, locale: nurse.locale

        expect(notification.reload.status).to eq "resolved"
      end
    end
  end
end
