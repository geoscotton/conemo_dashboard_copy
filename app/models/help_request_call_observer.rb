# frozen_string_literal: true
# Hook into Help Request Call lifecycle events.
class HelpRequestCallObserver < ActiveRecord::Observer
  def after_save(help_request_call)
    Tasks::HelpRequest.active.find_by(
      participant: help_request_call.participant
    ).try(:resolve)
  end
end
