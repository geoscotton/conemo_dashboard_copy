# Device serializer.
class DeviceSerializer < ActiveModel::Serializer
  attributes :device_uuid, :manufacturer, :model, :platform,
             :device_version
  attribute :uuid, key: :id
end
