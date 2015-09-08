# An imported copy of a ClientSessionEvent.
class SessionEvent < ActiveRecord::Base
  belongs_to :participant
  belongs_to :lesson

  validates :participant, :lesson, :occurred_at, :event_type, presence: true
end
