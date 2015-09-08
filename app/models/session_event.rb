# An imported copy of a ClientSessionEvent.
class SessionEvent < ActiveRecord::Base
  TYPES = Struct.new(:access).new("access").freeze

  belongs_to :participant
  belongs_to :lesson

  validates :participant, :lesson, :occurred_at, :event_type, presence: true

  scope :accesses, -> { where(event_type: TYPES.access) }
end
