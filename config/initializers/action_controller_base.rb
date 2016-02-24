# Spy on API requests.
ActionController::Base.class_eval do
  PAYLOADS_CONTROLLER = "payloads".freeze
  INDEX_ACTION = "index".freeze

  after_action :observe_request

  private

  def authenticated_payload_fetch?
    controller_name == PAYLOADS_CONTROLLER &&
      action_name == INDEX_ACTION &&
      @authentication_token
  end

  def observe_request
    if authenticated_payload_fetch?
      device = Device.find_by(device_uuid: @authentication_token.client_uuid)
      device.touch(:last_seen_at) if device
    end
  end
end
