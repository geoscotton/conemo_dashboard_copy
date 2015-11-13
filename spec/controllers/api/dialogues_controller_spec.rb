require "spec_helper"

RSpec.describe Api::DialoguesController, type: :controller do
  fixtures :all

  LOCALES = %w( en pt-BR es-PE )

  describe "GET index" do
    it "sets the lessons" do
      expect(LOCALES.all? do |locale|
        Dialogue.exists? locale: locale
      end).to be true

      get :index

      expect(assigns(:dialogues).count).to eq Dialogue.count
    end
  end
end
