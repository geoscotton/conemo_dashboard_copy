# frozen_string_literal: true
# PlannedActivity serializer.
class PlannedActivitySerializer < ActiveModel::Serializer
  attributes :name, :is_complete, :level_of_happiness, :how_worthwhile,
             :planned_at, :lesson_guid, :follow_up_at
  attribute :uuid, key: :id
end
