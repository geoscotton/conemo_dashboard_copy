# frozen_string_literal: true
require "rails_helper"

RSpec.describe ParticipantSummaryPresenter do
  describe "#active_tasks_list" do
    it "displays only active tasks" do
      tasks = [
        instance_double(NurseTask,
                        scheduled_at: Time.zone.now,
                        to_s: "active 1",
                        active?: true),
        instance_double(NurseTask,
                        scheduled_at: Time.zone.now,
                        to_s: "inactive 1",
                        active?: false)
      ]
      presenter = ParticipantSummaryPresenter.new(nil, tasks)

      expect(presenter.active_tasks_list).to eq "active 1"
    end

    it "displays tasks in order of scheduled_at timestamps" do
      tasks = [
        instance_double(NurseTask,
                        scheduled_at: Time.zone.local(2019),
                        to_s: "t3",
                        active?: true),
        instance_double(NurseTask,
                        scheduled_at: Time.zone.local(2014),
                        to_s: "t1",
                        active?: true),
        instance_double(NurseTask,
                        scheduled_at: Time.zone.local(2015),
                        to_s: "t2",
                        active?: true)
      ]
      presenter = ParticipantSummaryPresenter.new(nil, tasks)

      expect(presenter.active_tasks_list).to eq "t1, t2, t3"
    end
  end
end
