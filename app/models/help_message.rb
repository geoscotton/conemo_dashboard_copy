# receives data via prw staff message table
class HelpMessage < ActiveRecord::Base
  belongs_to :participant

  validates :read, inclusion: { in: [true, false] }
  validates :message, :sent_at, :participant, :uuid, presence: true

  before_validation :set_uuid

  private

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
