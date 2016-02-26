# frozen_string_literal: true
# SessionEvent serializer.
class SessionEventSerializer < ActiveModel::Serializer
  attributes :occurred_at, :lesson_guid, :event_type
  attribute :uuid, key: :id
end
