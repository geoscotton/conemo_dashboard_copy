# frozen_string_literal: true
# Manages Participants.
class Nurse < User
  belongs_to :nurse_supervisor
  has_many :participants,
           foreign_key: :nurse_id,
           dependent: :nullify,
           inverse_of: :nurse
  has_many :nurse_tasks, through: :participants
  has_many :supervision_sessions

  def active_participants
    participants.active
  end

  def current_tasks
    active_participant_tasks.current
  end

  def active_tasks
    active_participant_tasks.active
  end

  def overdue_tasks
    active_participant_tasks.overdue
  end

  def cancelled_tasks
    active_participant_tasks.cancelled
  end

  def rescheduled_tasks
    ScheduledTaskRescheduling.where(nurse_task: active_participant_tasks)
  end

  def cancelled_unscheduled_contacts
    [
      HelpRequestCall,
      LackOfConnectivityCall,
      NonAdherenceCall
    ].map do |contact_type|
      contact_type.where(participant: active_participants).cancelled
    end.flatten
  end

  private

  def active_participant_tasks
    nurse_tasks.where(participant: active_participants)
  end
end
