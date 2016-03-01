# frozen_string_literal: true
# Determine the appropriate CSS class and tasks to display for a Participant on
# a dashboard.
class ParticipantSummaryPresenter
  attr_reader :participant, :tasks

  delegate :id, :study_identifier, to: :participant
  delegate :count, to: :tasks, prefix: true

  CSS_CLASSES = Struct.new(:no_tasks, :overdue_tasks, :current_tasks)
                      .new("success", "danger", "warning")

  def initialize(participant, tasks)
    @participant = participant
    @tasks = ordered_tasks(tasks || [])
  end

  def active_tasks_list
    active_tasks.join ", "
  end

  def css_class
    if active_tasks.count == 0
      CSS_CLASSES.no_tasks
    elsif overdue_tasks.count > 0
      CSS_CLASSES.overdue_tasks
    else
      CSS_CLASSES.current_tasks
    end
  end

  def active_tasks
    tasks.select(&:active?)
  end

  def overdue_tasks
    active_tasks.select(&:overdue?)
  end

  def scheduled_tasks
    tasks.reject(&:alert?)
  end

  def latest_notification_at
    SupervisorNotification.where(
      nurse: participant.nurse,
      nurse_task: tasks
    ).order(:created_at).last.try(:created_at)
  end

  private

  def ordered_tasks(unordered_tasks)
    unordered_tasks.sort { |a, b| a.scheduled_at <=> b.scheduled_at }
  end
end
