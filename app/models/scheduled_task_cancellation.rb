# frozen_string_literal: true
# The record of a cancelled scheduled Nurse Task.
class ScheduledTaskCancellation < ActiveRecord::Base
  belongs_to :nurse_task

  validates :nurse_task, :explanation, presence: true
  validates :nurse_task_id, uniqueness: true
end
