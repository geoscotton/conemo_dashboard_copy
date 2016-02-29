# frozen_string_literal: true
# Determine the appropriate CSS class and tasks to display for a Participant on
# a dashboard.
class ParticipantSummaryPresenter
  attr_reader :participant, :tasks

  delegate :id, :study_identifier, to: :participant
  delegate :count, to: :tasks, prefix: true

  CSS_CLASSES = {
    no_tasks: "success",
    overdue_tasks: "danger",
    current_tasks: "warning"
  }.freeze

  def initialize(participant, tasks)
    @participant = participant
    @tasks = ordered_tasks(tasks || [])
  end

  def active_tasks_list
    tasks.select(&:active?).join ", "
  end

  def css_class
    if @tasks.count == 0
      CSS_CLASSES[:no_tasks]
    elsif @tasks.any?(&:overdue?)
      CSS_CLASSES[:overdue_tasks]
    else
      CSS_CLASSES[:current_tasks]
    end
  end

  def tasks_overdue
    tasks.select(&:overdue?)
  end

  private

  def ordered_tasks(unordered_tasks)
    unordered_tasks.sort { |a, b| a.scheduled_at <=> b.scheduled_at }
  end
end
