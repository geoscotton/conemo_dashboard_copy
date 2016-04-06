# frozen_string_literal: true
# The record of a rescheduled scheduled Nurse Task.
class ScheduledTaskRescheduling < ActiveRecord::Base
  belongs_to :nurse_task

  def participant_study_identifier
    nurse_task.participant.study_identifier
  end
end
