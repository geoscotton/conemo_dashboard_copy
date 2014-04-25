# Study phone given to Participant, or Participants own phone
class Smartphone < ActiveRecord::Base
  belongs_to :participant
  validates :number,
            :is_app_compatible,
            :participant,
            presence: true
end
