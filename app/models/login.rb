# Represents the Participant opening the mobile app.
class Login < ActiveRecord::Base
  belongs_to :participant

  validates :participant, :logged_in_at, presence: true

  before_validation :set_uuid

  private

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
