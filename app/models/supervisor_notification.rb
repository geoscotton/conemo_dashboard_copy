# frozen_string_literal: true
# A message from a Nurse to a Nurse Supervisor related to a Nurse Task.
class SupervisorNotification < ActiveRecord::Base
  STATUSES = Struct.new(:active, :cancelled, :resolved)
                   .new("active", "cancelled", "resolved")

  belongs_to :nurse_task

  validates :nurse_task, :status, presence: true
  validates :status, inclusion: { in: STATUSES.values }

  scope :active, -> { where(status: STATUSES.active) }

  def self.latest_for(task_id)
    where(nurse_task_id: task_id).order(:created_at).last
  end

  def self.active_for_nurse(nurse)
    active.where(nurse_task: nurse.active_tasks)
  end

  def self.active_for_nurse_and_participant(nurse, participant_id)
    active.where(nurse_task: nurse.active_tasks.where(participant_id: participant_id))
  end

  def nurse_supervisor
    nurse_task.nurse.nurse_supervisor
  end

  def resolve
    update status: STATUSES.resolved
  end
end
