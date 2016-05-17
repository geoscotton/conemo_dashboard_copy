# frozen_string_literal: true
module TokenAuth
  # Observe Authentication Token lifecycle events.
  class AuthenticationTokenObserver < ActiveRecord::Observer
    def after_destroy(token)
      device = Device.find_by_participant_id(token.entity_id)

      return unless device

      PastDeviceAssignment.create(device.attributes)
      device.destroy
    end
  end
end
