# frozen_string_literal: true
# Login serializer.
class LoginSerializer < ActiveModel::Serializer
  attributes :logged_in_at
  attribute :uuid, key: :id
end
