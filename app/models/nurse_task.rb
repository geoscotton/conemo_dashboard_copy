require "ostruct"

# Superclass for scheduled and triggered Nurse Tasks.
class NurseTask < ActiveRecord::Base
  STATUSES = OpenStruct.new(active: "active")

  belongs_to :nurse, foreign_key: :user_id
  belongs_to :participant

  validates :nurse, :participant, :status, :scheduled_at, :overdue_at,
            presence: true
  validates :status, inclusion: { in: STATUSES.to_h.values }
  validates :user_id, uniqueness: { scope: [:participant_id, :type] }

  before_validation :set_scheduled_at
  before_validation :set_overdue_at

  def self.for_nurse_and_participant(nurse, participant)
    where nurse: nurse, participant: participant
  end

  def self.active
    where status: STATUSES.active
  end

  def self.overdue
    where(arel_table[:overdue_at].lteq(Time.zone.now))
  end

  private

  def set_scheduled_at
    self.scheduled_at ||= Time.zone.now
  end

  def set_overdue_at
    return if scheduled_at.blank? || nurse.blank?

    local_scheduled_at = scheduled_at.in_time_zone(nurse.timezone)
    overdue_days_offset = if local_scheduled_at < local_scheduled_at.at_noon
                            self.class::OVERDUE_AFTER_DAYS + 1
                          else
                            self.class::OVERDUE_AFTER_DAYS + 2
                          end
    self.overdue_at = overdue_days_offset.business_days
                                         .after(local_scheduled_at)
                                         .at_beginning_of_day
  end
end
