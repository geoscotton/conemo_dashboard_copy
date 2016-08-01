# frozen_string_literal: true
# Calculates connectivity presence/absence.
class DeviceConnectivityPresenter
  LACK_OF_CONNECTIVITY_THRESHOLD = 12.hours

  def initialize(participant)
    @participant = participant
  end

  def last_seen_at_str
    device_last_seen_at ? I18n.l(device_last_seen_at, format: :long) : "?"
  end

  # Returns true if lack of connectivity is detected for the given release day.
  def lack_of_on_release_day?(release_day, next_release_day)
    released_at = release_timestamp(release_day)
    next_released_at = next_release_day.nil? ? nil : release_timestamp(next_release_day)

    return false if !next_released_at.nil? &&
                    (next_released_at - device_last_seen_at <
                     LACK_OF_CONNECTIVITY_THRESHOLD)

    return true if Time.zone.now - [device_last_seen_at, released_at].max >=
                   LACK_OF_CONNECTIVITY_THRESHOLD

    return true if released_at - device_last_seen_at >=
                   LACK_OF_CONNECTIVITY_THRESHOLD

    false
  end

  def release_timestamp(release_day)
    (@participant.start_date + release_day.days).beginning_of_day + 8.hours
  end

  private

  def device_last_seen_at
    @device_last_seen_at ||= Device.find_by(participant: @participant)
                                   .try(:last_seen_at)
  end
end
