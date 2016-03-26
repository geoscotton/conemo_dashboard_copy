# frozen_string_literal: true
# Determine the appropriate CSS class for a Supervision Session.
class SupervisionSessionPresenter
  attr_reader :supervision_session, :nurse

  TARDY_DAYS = 8
  LATE_DAYS = 12
  CSS_CLASSES = Struct.new(:current, :tardy, :late)
                      .new("", "text-warning", "text-danger")

  def initialize(supervision_session)
    @supervision_session = supervision_session
    @nurse = supervision_session.nurse
  end

  def css_class
    offset = local_session_at < local_session_at.at_noon ? 0 : 1

    if (LATE_DAYS + offset).business_days
                           .after(local_session_at)
                           .at_beginning_of_day <= now

      CSS_CLASSES.late
    elsif (TARDY_DAYS + offset).business_days
                               .after(local_session_at)
                               .at_beginning_of_day <= now

      CSS_CLASSES.tardy
    else
      CSS_CLASSES.current
    end
  end

  private

  def now
    @now ||= Time.zone.now
  end

  def local_session_at
    @local_session_at ||= (
      session_at = supervision_session.session_at

      session_at.in_time_zone(nurse.timezone)
    )
  end
end
