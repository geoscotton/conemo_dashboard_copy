# frozen_string_literal: true
# ContentAccessEvent serializer.
class ContentAccessEventSerializer < ActiveModel::Serializer
  attributes :accessed_at, :lesson_guid
  attribute :uuid, key: :id
end
