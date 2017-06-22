# frozen_string_literal: true
# Hook into Non Adherence Call lifecycle events.
class NonAdherenceCallObserver < ActiveRecord::Observer
  def after_save(non_adherence_call)
    Tasks::NonAdherenceCall.active.find_by(
      participant: non_adherence_call.participant
    ).try(:resolve)
  end
end
