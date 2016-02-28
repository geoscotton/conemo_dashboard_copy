# frozen_string_literal: true
require "rails_helper"

RSpec.describe ParticipantSummaryPresenter do
  describe "#tasks_list" do
    it "displays tasks in order of scheduled_at timestamps" do
      tasks = [
        instance_double(NurseTask,
                        scheduled_at: Time.zone.local(2019),
                        to_s: "t3"),
        instance_double(NurseTask,
                        scheduled_at: Time.zone.local(2014),
                        to_s: "t1"),
        instance_double(NurseTask,
                        scheduled_at: Time.zone.local(2015),
                        to_s: "t2")
      ]
      presenter = ParticipantSummaryPresenter.new(nil, tasks)

      expect(presenter.tasks_list).to eq "t1, t2, t3"
    end
  end
end
