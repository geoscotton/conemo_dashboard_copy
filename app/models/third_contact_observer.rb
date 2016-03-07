# frozen_string_literal: true
# Hook into Third Contact lifecycle events.
class ThirdContactObserver < ActiveRecord::Observer
  def after_create(third_contact)
    Tasks::FollowUpCallWeekThree.active.find_by(
      participant: third_contact.participant
    ).try(:resolve)
  end
end
