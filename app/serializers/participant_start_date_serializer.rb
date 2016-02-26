# frozen_string_literal: true
# ParticipantStartDate serializer.
class ParticipantStartDateSerializer < ActiveModel::Serializer
  attributes :date
  attribute :uuid, key: :id
end
