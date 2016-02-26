# frozen_string_literal: true
require "spec_helper"

RSpec.describe Api::LessonsController, type: :controller do
  fixtures :all

  describe "GET index" do
    it "sets the lessons" do
      expect(LOCALES.values.all? do |locale|
        Lesson.exists? locale: locale
      end).to be true

      get :index

      expect(assigns(:lessons).count).to eq Lesson.count
    end
  end
end
