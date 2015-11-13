require "spec_helper"

RSpec.describe Api::LessonsController, type: :controller do
  LOCALES = %w( en pt-BR es-PE )

  fixtures :all

  describe "GET index" do
    it "sets the lessons" do
      expect(LOCALES.all? do |locale|
        Lesson.exists? locale: locale
      end).to be true

      get :index

      expect(assigns(:lessons).count).to eq Lesson.count
    end
  end
end
