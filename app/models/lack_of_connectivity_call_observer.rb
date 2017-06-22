# frozen_string_literal: true
# Hook into Lack of Connectivity Call lifecycle events.
class LackOfConnectivityCallObserver < ActiveRecord::Observer
  def after_save(lack_of_connectivity_call)
    Tasks::LackOfConnectivityCall.active.find_by(
      participant: lack_of_connectivity_call.participant
    ).try(:resolve)
  end
end
