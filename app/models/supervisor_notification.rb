# frozen_string_literal: true
# A message from a Nurse to a Nurse Supervisor related to a Nurse Task.
class SupervisorNotification < ActiveRecord::Base
  STATUSES = Struct.new(:active, :cancelled, :resolved)
                   .new("active", "cancelled", "resolved")

  belongs_to :nurse_supervisor
  belongs_to :nurse_task

  validates :nurse_supervisor, :nurse_task, :status, presence: true
  validates :status, inclusion: { in: STATUSES.values }

  def self.latest_for(task_id)
    where(nurse_task_id: task_id).order(:created_at).last
  end
end
