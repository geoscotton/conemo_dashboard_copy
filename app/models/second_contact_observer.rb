# frozen_string_literal: true
# Hook into Second Contact lifecycle events.
class SecondContactObserver < ActiveRecord::Observer
  def after_create(second_contact)
    Tasks::FollowUpCallWeekOne.active.find_by(
      participant: second_contact.participant
    ).try(:resolve)
  end
end
