# An imported copy of a ClientSessionEvent.
class SessionEvent < ActiveRecord::Base
  TYPES = Struct.new(:access).new("access").freeze

  belongs_to :participant
  belongs_to :lesson

  validates :participant, :lesson, :occurred_at, :event_type, presence: true

  scope :accesses, -> { where(event_type: TYPES.access) }

  def late?
    day_in_treatment_accessed > lesson.day_in_treatment
  end

  private

  def day_in_treatment_accessed
    occurred_at.to_date - participant.start_date + 1
  end
end
