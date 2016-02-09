require "spec_helper"

RSpec.describe DebugLogsController, type: :controller do
  describe "POST create" do
    it "responds with 200" do
      post :create,
           json: {
             timestamp: Time.zone.now.to_i,
             user_id: "foo",
             event_type: "bar"
           }.to_json

      expect(response.status).to eq 200
    end
  end
end
