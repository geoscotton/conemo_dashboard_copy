# frozen_string_literal: true
require "rails_helper"

module Active
  RSpec.describe ParticipantsController, type: :controller do
    fixtures :users, :participants

    let(:locale) { LOCALES.values.sample }

    describe "GET show" do
      it "sets the participant" do
        participant = Participant.where(locale: locale).first

        admin_request :get, :show, locale, id: participant.id, locale: locale

        expect(assigns(:participant)).to eq participant
      end
    end

    describe "GET report" do
      it "sets the participant" do
        participant = Participant.where(locale: locale).first

        admin_request :get, :report, locale, id: participant.id, locale: locale

        expect(assigns(:participant)).to eq participant
      end
    end
  end
end
