# frozen_string_literal: true
module Tasks
  module AlertRules
    # Determines when network connectivity has been absent and is alertable.
    module LackOfConnectivity
      ALERTABLE_AFTER_DAYS = 2
      TASK_FREE_PERIOD = 12.hours

      class << self
        def create_tasks(devices = nil)
          devices ||= Device.all
          devices.each do |d|
            if triggered?(d)
              report(d.participant)
            elsif recently_seen?(d)
              delete_active(d.participant)
            end
          end
        end

        def triggered?(device)
          unless device.participant.status == Participant::ACTIVE &&
                 device.participant.nurse.present? &&
                 !recently_resolved_task_exists?(device.participant)
            return false
          end

          Time.zone.now - device.last_seen_at > ALERTABLE_AFTER_DAYS.days
        end

        def report(participant)
          Tasks::LackOfConnectivityCall.create(participant: participant)
        end

        def recently_resolved_task_exists?(participant)
          task = Tasks::LackOfConnectivityCall
                 .resolved
                 .where(participant: participant)
                 .order(:updated_at)
                 .last

          task.present? && Time.zone.now - task.updated_at < TASK_FREE_PERIOD
        end

        def recently_seen?(device)
          Time.zone.now - device.last_seen_at < 15.minutes
        end

        def delete_active(participant)
          Tasks::LackOfConnectivityCall
            .active
            .where(participant: participant)
            .map(&:soft_delete)
        end
      end
    end
  end
end
