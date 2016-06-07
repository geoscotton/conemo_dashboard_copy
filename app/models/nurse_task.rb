# frozen_string_literal: true
# Superclass for scheduled and triggered Nurse Tasks.
class NurseTask < ActiveRecord::Base
  STATUSES = Struct.new(:active, :resolved, :cancelled, :deleted)
                   .new("active", "resolved", "cancelled", "deleted")

  belongs_to :participant
  has_many :scheduled_task_cancellations, dependent: :destroy
  has_many :scheduled_task_reschedulings, dependent: :destroy
  has_many :supervisor_notifications, dependent: :destroy

  validates :participant, :status, :scheduled_at, :overdue_at,
            presence: true
  validates :status, inclusion: { in: STATUSES.to_h.values }

  before_validation :set_scheduled_at
  before_validation :set_overdue_at

  delegate :nurse, to: :participant

  def self.for_participant(participant)
    where participant: participant
  end

  def self.current
    active.where(arel_table[:scheduled_at].lteq(Time.zone.now))
  end

  def self.active
    where status: STATUSES.active
  end

  def self.resolved
    where status: STATUSES.resolved
  end

  def self.deleted
    where status: STATUSES.deleted
  end

  def self.cancelled
    where status: STATUSES.cancelled
  end

  def self.overdue
    active
      .where(arel_table[:overdue_at].lteq(Time.zone.now))
  end

  def active?
    status == STATUSES.active
  end

  def resolved?
    status == STATUSES.resolved
  end

  def cancelled?
    status == STATUSES.cancelled
  end

  def due?
    scheduled_at.to_date <= Time.zone.today
  end

  def to_s
    self.class.model_name.human
  end

  def overdue?
    Time.zone.now >= overdue_at
  end

  def alert?
    false
  end

  def cancel
    update status: STATUSES.cancelled
  end

  def resolve
    update status: STATUSES.resolved
  end

  def soft_delete
    update status: STATUSES.deleted
  end

  def reschedule_at(time)
    update scheduled_at: time
  end

  def target
    raise "implement in subclass"
  end

  def cancellation_explanation
    ScheduledTaskCancellation.find_by(nurse_task: self).try(:explanation)
  end

  private

  def symbolize(klass)
    klass.to_s.underscore.to_sym
  end

  def set_scheduled_at
    self.scheduled_at ||= Time.zone.now
  end

  def set_overdue_at
    return if scheduled_at.blank? || participant.blank?

    local_scheduled_at = scheduled_at.in_time_zone(participant.nurse.timezone)
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
