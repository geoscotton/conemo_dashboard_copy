require "fileutils"

# Handle debug logs from Purple Robot.
class DebugLogsController < ActionController::Base
  DEBUG_LOG_PATH = "log/debug_logs"

  def create
    payload = JSON.parse(params[:json])
    timestamp = Time.zone.at(payload["timestamp"]).iso8601
    dir = Rails.root.join(DEBUG_LOG_PATH)
    FileUtils.mkdir_p(dir)
    file = File.join(dir, "USER_#{ sanitize(payload['user_id']) }_" \
                          "EVENT_TYPE_#{ sanitize(payload['event_type']) }_" \
                          "TIMESTAMP_#{ timestamp }")
    unless File.exist?(file)
      File.open(file, "w") do |f|
        f.write JSON.pretty_generate(payload)
      end
    end

    render json: { result: "success" }, status: 200
  rescue StandardError
    render json: { result: "error", message: "Unknown error" }, status: 500
  end

  private

  def sanitize(value)
    value.gsub(/[^-_a-z0-9]+/mi, "")
  end
end
