# Login serializer.
class LoginSerializer < ActiveModel::Serializer
  attributes :logged_in_at
  attribute :uuid, key: :id
end
