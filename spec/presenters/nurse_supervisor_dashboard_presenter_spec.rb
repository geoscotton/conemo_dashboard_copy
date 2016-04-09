# frozen_string_literal: true
require "rails_helper"

RSpec.describe NurseSupervisorDashboardPresenter do
  fixtures :all

  let(:task) { NurseTask.first }
  let(:nurse) { task.participant.nurse }
  let(:nurse_supervisor) { nurse.nurse_supervisor }
  let(:participants) { nurse.participants }
  let(:just_now) { Time.zone.now - 1.second }
  let(:yesterday) { Time.zone.now - 1.day }
  let(:tomorrow) { Time.zone.now + 1.day }

  describe "#overdue_nurses" do
    it "returns nurses who have overdue tasks for active participants" do
      task.update_column :overdue_at, yesterday
      presenter = NurseSupervisorDashboardPresenter.new(nurse_supervisor,
                                                        participants)

      expect(presenter.overdue_nurses).to eq([nurse])
    end
  end

  describe "#current_nurses" do
    it "returns nurses who have current tasks for active participants" do
      nurse_supervisor.active_participant_tasks.each do |t|
        t.update(scheduled_at: just_now)
      end
      presenter = NurseSupervisorDashboardPresenter.new(nurse_supervisor,
                                                        participants)

      expect(presenter.current_nurses).to eq([nurse])
    end
  end

  describe "#complete_nurses" do
    it "returns nurses with no current/overdue tasks for active participants" do
      nurse_supervisor.active_participant_tasks.each do |t|
        t.update(scheduled_at: tomorrow)
      end
      presenter = NurseSupervisorDashboardPresenter.new(nurse_supervisor,
                                                        participants)

      expect(presenter.complete_nurses).to eq([nurse])
    end
  end
end
