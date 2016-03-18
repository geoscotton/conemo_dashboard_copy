# frozen_string_literal: true
# Hook into Participant lifecycle events.
class ParticipantObserver < ActiveRecord::Observer
  def after_save(participant)
    return unless participant.nurse

    Tasks::ConfirmationCall.create(participant: participant)
  end
end
