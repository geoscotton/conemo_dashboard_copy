# frozen_string_literal: true
# Hook into Help Message lifecycle events.
class HelpMessageObserver < ActiveRecord::Observer
  def after_create(help_message)
    Tasks::HelpRequest.create(
      participant: help_message.participant,
      scheduled_at: help_message.sent_at
    )
  end
end
