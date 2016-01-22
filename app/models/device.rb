# A physical device used by a Participant.
class Device < ActiveRecord::Base
  validates :uuid, :device_uuid, :manufacturer, :model, :platform,
            :device_version, :inserted_at, presence: true
  validates :uuid, :device_uuid, uniqueness: true

  before_validation :add_inserted_at

  private

  def add_inserted_at
    self.inserted_at = Time.zone.now
  end
end
