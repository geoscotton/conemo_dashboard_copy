# An interaction with an app Session (Lesson).
class ClientSessionEvent < ActiveRecord::Base
  TYPES = Struct.new(:access).new("access").freeze

  establish_connection :prw

  self.table_name = "session_events"

  alias_attribute :participant_identifier, :FEATURE_VALUE_DT_userId
  alias_attribute :lesson_guid, :FEATURE_VALUE_DT_lessonGuid
  alias_attribute :event_type, :FEATURE_VALUE_DT_eventType
  alias_attribute :occurred_at, :eventDateTime

  scope :access_events, -> { where(FEATURE_VALUE_DT_eventType: TYPES.access) }
end
