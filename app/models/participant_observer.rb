# Hook into Participant lifecycle events.
class ParticipantObserver < ActiveRecord::Observer
  def after_save(participant)
    Tasks::ConfirmationCall.create(
      nurse: participant.nurse,
      participant: participant
    )
  end
end
