# frozen_string_literal: true
# Presentation and ordering logic for the Nurse dashboard.
class NurseDashboardPresenter
  attr_reader :participants

  def initialize(nurse)
    @participants = nurse.active_participants
    @tasks_by_id = nurse.nurse_tasks.group_by(&:participant_id)
  end

  def participant_summaries
    summaries = participants.map do |p|
      ParticipantSummaryPresenter.new(p, @tasks_by_id[p.id])
    end

    summaries.sort do |a, b|
      latest_participant_task_date(a) <=> latest_participant_task_date(b)
    end
  end

  private

  def latest_participant_task_date(row)
    fake_late_date = 9999999999999

    row.tasks.first.try(:scheduled_at).try(:to_i) || fake_late_date
  end
end
