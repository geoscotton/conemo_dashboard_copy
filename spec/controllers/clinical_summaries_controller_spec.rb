# frozen_string_literal: true
require "rails_helper"

RSpec.describe ClinicalSummariesController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }

  describe "GET show" do
    it "sets the participant" do
      participant = Participant.where(locale: locale).first
      sign_in_user NurseSupervisor.where(locale: locale).first

      get :show, locale: locale, participant_id: participant.id

      expect(assigns(:participant)).to eq participant
    end
  end
end
