# frozen_string_literal: true
# Presentation and ordering logic for the Nurse dashboard.
class NurseDashboardPresenter
  attr_reader :participants

  def initialize(nurse)
    @participants = nurse.active_participants
    @tasks_by_id = NurseTask.where(participant_id: @participants.map(&:id))
                            .group_by(&:participant_id)
  end

  def participant_summaries
    summaries = participants.map do |p|
      ParticipantSummaryPresenter.new(p, @tasks_by_id[p.id])
    end

    [
      overdue_summaries(summaries).sort do |a, b|
        most_overdue_participant_task(a) <=> most_overdue_participant_task(b)
      end,
      current_summaries(summaries).sort do |a, b|
        oldest_participant_task(a) <=> oldest_participant_task(b)
      end,
      complete_summaries(summaries)
    ].flatten
  end

  private

  def overdue_summaries(summaries)
    summaries.select do |s|
      s.css_class == ParticipantSummaryPresenter::CSS_CLASSES.overdue_tasks
    end
  end

  def current_summaries(summaries)
    summaries.select do |s|
      s.css_class == ParticipantSummaryPresenter::CSS_CLASSES.current_tasks
    end
  end

  def complete_summaries(summaries)
    summaries.select do |s|
      s.css_class == ParticipantSummaryPresenter::CSS_CLASSES.no_tasks
    end
  end

  def oldest_participant_task(row)
    fake_late_date = 9999999999999

    row.active_tasks.first.try(:scheduled_at).try(:to_i) || fake_late_date
  end

  def most_overdue_participant_task(row)
    fake_late_date = 9999999999999

    row.active_tasks.first.try(:overdue_at).try(:to_i) || fake_late_date
  end
end
