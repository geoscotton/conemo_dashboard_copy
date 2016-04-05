# frozen_string_literal: true
# Manages Participant and Nurse assignments.
class NurseSupervisor < User
  has_many :nurses
  has_many :participants, through: :nurses

  def active_participants
    participants.active
  end
end
