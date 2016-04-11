# frozen_string_literal: true
# Manages Participant and Nurse assignments.
class NurseSupervisor < User
  has_many :nurses, dependent: :nullify
  has_many :participants, through: :nurses

  def active_participants
    participants.active
  end

  def active_participant_tasks
    NurseTask.where(participant: active_participants)
  end
end
