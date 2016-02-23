# Hook into Participant lifecycle events.
class ParticipantObserver < ActiveRecord::Observer
  def after_save(participant)
    Tasks::ConfirmationCall.create_for_nurse_and_participant(participant.nurse,
                                                             participant)
  end
end
