# HelpMessage serializer.
class HelpMessageSerializer < ActiveModel::Serializer
  attributes :message, :sent_at
  attribute :uuid, key: :id
end
