# Hook into Help Message lifecycle events.
class HelpMessageObserver < ActiveRecord::Observer
  def after_create(help_message)
    Tasks::HelpRequest.create(
      nurse: help_message.participant.nurse,
      participant: help_message.participant,
      scheduled_at: help_message.sent_at
    )
  end
end
