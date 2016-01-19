# A physical device used by a Participant.
class Device < ActiveRecord::Base
  validates :uuid, :device_uuid, :manufacturer, :model, :platform,
            :device_version, :inserted_at, presence: true
  validates :uuid, :device_uuid, uniqueness: true
end
