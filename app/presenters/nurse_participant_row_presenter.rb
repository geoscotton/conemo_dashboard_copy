# Determine the appropriate CSS class to use for a Participant row on the Nurse
# dashboard.
class NurseParticipantRowPresenter
  attr_reader :participant, :tasks

  delegate :id, :study_identifier, to: :participant

  CSS_CLASSES = {
    no_tasks: "success",
    overdue_tasks: "danger",
    current_tasks: "warning"
  }.freeze

  def initialize(participant, tasks)
    @participant = participant
    @tasks = tasks || []
  end

  def tasks_list
    @tasks.join ", "
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
end
