module Tasks
  module AlertRules
    # Determines when network connectivity has been absent and is alertable.
    module LackOfConnectivity
      ALERTABLE_AFTER_DAYS = 2

      class << self
        def create_tasks(devices = nil)
          devices ||= Device.all
          devices.each { |d| report(d.participant) if triggered?(d) }
        end

        def triggered?(device)
          Time.zone.now - device.last_seen_at > ALERTABLE_AFTER_DAYS.days
        end

        def report(participant)
          Tasks::LackOfConnectivityCall.create(
            nurse: participant.nurse,
            participant: participant
          )
        end
      end
    end
  end
end
