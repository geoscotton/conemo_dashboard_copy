# frozen_string_literal: true
# A message from a Nurse to a Nurse Supervisor related to a Nurse Task.
class SupervisorNotification < ActiveRecord::Base
  STATUSES = Struct.new(:active, :cancelled, :resolved)
                   .new("active", "cancelled", "resolved")

  belongs_to :nurse
  belongs_to :nurse_supervisor
  belongs_to :nurse_task

  validates :nurse, :nurse_supervisor, :nurse_task, :status, presence: true
  validates :status, inclusion: { in: STATUSES.values }

  def self.latest_for(task)
    where(nurse_task: task).order(:created_at).last
  end
end
