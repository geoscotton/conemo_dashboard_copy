# frozen_string_literal: true
require "rails_helper"

RSpec.describe Nurse do
  fixtures :all

  let(:task) { NurseTask.first }
  let(:nurse) { task.nurse }

  describe "#current_tasks" do
    it "returns current tasks for active participants" do
      task.update(status: NurseTask::STATUSES.active,
                  scheduled_at: Time.zone.now - 1.day)

      expect(nurse.current_tasks).to include task
    end
  end

  describe "#active_tasks" do
    it "returns active tasks for active participants" do
      task.update(status: NurseTask::STATUSES.active)

      expect(nurse.active_tasks).to include task
    end
  end

  describe "#overdue_tasks" do
    it "returns overdue tasks for active participants" do
      task.update(status: NurseTask::STATUSES.active,
                  scheduled_at: Time.zone.now - 1.month)

      expect(nurse.overdue_tasks).to include task
    end
  end

  describe "#cancelled_tasks" do
    it "returns current tasks for active participants" do
      task.update(status: NurseTask::STATUSES.cancelled)

      expect(nurse.cancelled_tasks).to include task
    end
  end

  describe "#rescheduled_tasks" do
    it "returns current tasks for active participants" do
    end
  end
end
