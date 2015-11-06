require "spec_helper"

RSpec.describe DebugLogsController, type: :controller do
  describe "POST create" do
    it "generates a log file" do
      log_path = Rails.root.join("log/debug_logs")

      expect do
        post :create,
             json: {
               timestamp: Time.zone.now.to_i,
               user_id: "foo",
               event_type: "bar"
             }.to_json
      end.to change { Dir[Rails.root.join("log/debug_logs")].count }.by(1)

      Dir["#{ log_path }/USER*"].each { |f| File.delete(f) }
      Dir.delete(log_path)
    end

    context "when the parameters are malformed" do
      it "returns a server error" do
        post :create, json: "asdf"

        expect(response.status).to eq 500
      end
    end
  end
end
