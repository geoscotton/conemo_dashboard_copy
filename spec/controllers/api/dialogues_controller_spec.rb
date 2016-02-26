# frozen_string_literal: true
require "spec_helper"

RSpec.describe Api::DialoguesController, type: :controller do
  fixtures :all

  describe "GET index" do
    it "sets the lessons" do
      expect(LOCALES.values.all? do |locale|
        Dialogue.exists? locale: locale
      end).to be true

      get :index

      expect(assigns(:dialogues).count).to eq Dialogue.count
    end
  end
end
