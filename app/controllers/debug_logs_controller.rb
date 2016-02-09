# Handle debug logs from Purple Robot.
class DebugLogsController < ActionController::Base
  def create
    render json: { result: "success" }, status: 200
  end
end
