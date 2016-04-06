# frozen_string_literal: true
# The record of a rescheduled scheduled Nurse Task.
class ScheduledTaskRescheduling < ActiveRecord::Base
  belongs_to :nurse_task
end
