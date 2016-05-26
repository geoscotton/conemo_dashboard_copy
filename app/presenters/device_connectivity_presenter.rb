# frozen_string_literal: true
# Calculates connectivity presence/absence.
class DeviceConnectivityPresenter
  LACK_OF_CONNECTIVITY_THRESHOLD = 12.hours

  attr_reader :device_last_seen_at

  def initialize(participant)
    @device_last_seen_at = Device.find_by(participant: participant)
                                 .try(:last_seen_at)
  end

  def last_seen_at_str
    device_last_seen_at ? I18n.l(device_last_seen_at, format: :long) : "?"
  end

  # Returns true if lack of connectivity is detected by the given date.
  def lost_by?(date)
    lost_on && date && lost_on <= date
  end

  private

  def lost_on
    @lost_on ||= (
      if device_last_seen_at &&
         Time.zone.now - LACK_OF_CONNECTIVITY_THRESHOLD >= device_last_seen_at
        return (device_last_seen_at + LACK_OF_CONNECTIVITY_THRESHOLD).to_date
      end

      Date.tomorrow
    )
  end
end
