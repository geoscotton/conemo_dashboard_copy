# frozen_string_literal: true
require "rails_helper"
require "ostruct"
require_relative "../../config/initializers/action_controller_base"

class MockPayloadsController < ActionController::Base
end

RSpec.describe "payload fetch observance", type: :controller do
  controller MockPayloadsController do
    def index
      @authentication_token = OpenStruct.new(client_uuid: "123")
      render text: ""
    end
  end

  context "when the payloads controller index action is called" do
    context "and an authentication token is found" do
      it "updates the associated device last_seen_at column" do
        Device.destroy_all
        Device.create!(
          uuid: "abc",
          device_uuid: "123",
          manufacturer: "m",
          model: "m",
          platform: "p",
          device_version: "d"
        )
        allow(controller).to receive(:controller_name) { "payloads" }

        expect do
          get :index
        end.to change { Device.find_by(device_uuid: "123").last_seen_at }
      end
    end
  end
end
