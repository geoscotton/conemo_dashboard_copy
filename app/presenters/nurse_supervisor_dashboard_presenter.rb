# frozen_string_literal: true
# Presentation and ordering logic for the Nurse Supervisor dashboard.
class NurseSupervisorDashboardPresenter
  attr_reader :nurse_supervisor, :nurses, :active_participants

  delegate :active_participant_tasks, to: :nurse_supervisor

  def initialize(nurse_supervisor, active_participants)
    @nurse_supervisor = nurse_supervisor
    @nurses = nurse_supervisor.nurses.includes(:supervision_sessions)
    @active_participants = active_participants
  end

  def overdue_nurses
    @overdue_nurses ||= (
      overdue_nurses = active_participant_tasks.overdue.group_by do |t|
        participants_by_id[t.participant_id].first.nurse
      end

      overdue_nurses = overdue_nurses.sort_by do |_nurse, tasks|
        tasks.sort_by(&:overdue_at).first.overdue_at
      end

      overdue_nurses.map(&:first)
    )
  end

  def current_nurses
    @current_nurses ||= (
      current_nurses = active_participant_tasks.current.group_by do |t|
        participants_by_id[t.participant_id].first.nurse
      end

      current_nurses.delete_if { |k| !non_overdue_nurse_ids.include?(k.id) }

      current_nurses = current_nurses.sort_by do |_nurse, tasks|
        tasks.sort_by(&:scheduled_at).first.scheduled_at
      end

      current_nurses.map(&:first)
    )
  end

  def complete_nurses
    nurses.select do |n|
      !overdue_nurses.include?(n) && !current_nurses.include?(n)
    end
  end

  private

  def participants_by_id
    @participants_by_id ||=
      active_participants.includes(:nurse).group_by(&:id)
  end

  def non_overdue_nurse_ids
    @non_overdue_nurse_ids ||=
      (nurse_supervisor.nurse_ids - overdue_nurses.map(&:id))
  end
end
