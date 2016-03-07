# frozen_string_literal: true
# Presentational information for a Nurse Task.
class TaskPresenter
  CSS_CLASSES = Struct.new(:future, :resolved, :active, :cancelled)
                      .new("future", "success", "warning", "danger")

  attr_reader :task

  delegate :active?, :alert?, :cancelled?, :due?, :id, :overdue?, :resolved?,
           :scheduled_at, :target, :to_s, to: :task

  def initialize(task)
    @task = task
  end

  def css_class
    if active?
      if scheduled_at.to_date > Time.zone.today
        CSS_CLASSES.future
      else
        CSS_CLASSES.active
      end
    elsif resolved?
      CSS_CLASSES.resolved
    elsif cancelled?
      CSS_CLASSES.cancelled
    end
  end
end
