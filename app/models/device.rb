# A physical device used by a Participant.
class Device < ActiveRecord::Base
  belongs_to :participant

  validates :uuid, :device_uuid, :manufacturer, :model, :platform,
            :device_version, :inserted_at, :last_seen_at, presence: true
  validates :uuid, :device_uuid, uniqueness: true

  before_validation :add_inserted_at
  before_validation :add_last_seen_at

  private

  def add_inserted_at
    self.inserted_at ||= Time.zone.now
  end

  def add_last_seen_at
    self.last_seen_at ||= Time.zone.now
  end
end
