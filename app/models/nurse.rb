# frozen_string_literal: true
# Manages Participants.
class Nurse < User
  belongs_to :nurse_supervisor
  has_many :participants,
           foreign_key: :nurse_id,
           dependent: :nullify,
           inverse_of: :nurse
  has_many :nurse_tasks, through: :participants

  def active_participants
    participants.active
  end

  def active_tasks
    nurse_tasks
      .active
      .where(participant: active_participants)
  end

  def overdue_tasks
    nurse_tasks
      .overdue
      .where(participant: active_participants)
  end
end
