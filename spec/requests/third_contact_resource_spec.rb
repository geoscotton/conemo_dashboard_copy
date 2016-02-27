# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Third Contact resource requests", type: :request do
  describe "GET show" do
    it "redirects to the active participants index" do
      get "/en/participants/123/third_contact"

      expect(response).to redirect_to("/en/active/participants")
    end
  end
end
