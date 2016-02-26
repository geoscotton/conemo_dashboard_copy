# frozen_string_literal: true
require "spec_helper"

describe Pending::ParticipantsController, type: :controller do
  fixtures :users, :participants

  let(:locale) { LOCALES.values.sample }

  describe "GET index" do
    context "for authenticated requests" do
      it "should render the index page" do
        admin_request :get, :index, locale, locale: locale

        expect(response).to render_template :index
      end
    end
  end

  describe "GET activate" do
    context "for unauthenticated requests" do
      before { get :activate, id: 1, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests" do
      context "when the participant is found" do
        it "should render the activate page" do
          allow(Participant).to receive(:find)
            .and_return(Participant.new(locale: locale))

          admin_request :get, :activate, locale, id: 1, locale: locale

          expect(response).to render_template :activate
        end
      end

      context "when the participant is not found" do
        it "should redirect to the index page" do
          allow(Participant).to receive_message_chain("pending.find")
            .and_raise(ActiveRecord::RecordNotFound)

          admin_request :get, :activate, locale, id: 1, locale: locale

          expect(response).to redirect_to pending_participants_url
        end
      end
    end
  end
end
