# Defines a dialogue to be presented to a Participant using the mobile app.
class Dialogue < ActiveRecord::Base
  has_many :content_access_events
  has_many :participants, through: :content_access_events
  
  before_validation :generate_guid

  validates :title,
          :day_in_treatment,
          :locale,
          :guid,
          :message,
          :yes_text,
          :no_text,
          presence: true

  private

  def generate_guid
    self.guid = SecureRandom.uuid
  end
end
