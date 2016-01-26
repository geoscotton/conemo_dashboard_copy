# Reflects the date on which a Participant's phone is configured.
class ParticipantStartDate < ActiveRecord::Base
  belongs_to :participant

  validates :uuid, :date, :participant, presence: true
  validates :participant_id, uniqueness: true
end
