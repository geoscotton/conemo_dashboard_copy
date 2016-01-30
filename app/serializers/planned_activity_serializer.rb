# PlannedActivity serializer.
class PlannedActivitySerializer < ActiveModel::Serializer
  attributes :name, :is_complete, :planned_at, :lesson_guid
  attribute :uuid, key: :id
end
