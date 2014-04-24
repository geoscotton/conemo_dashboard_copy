# Study phone given to Participant, or Participants own phone
class Smartphone < ActiveRecord::Base
  belongs_to :participant, dependent: :destroy
  validates :number,
            :is_app_compatible,
            :participant_id,
            presence: true
end
