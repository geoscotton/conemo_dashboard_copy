# frozen_string_literal: true
require "rails_helper"

RSpec.describe ParticipantSummaryPresenter do
  def stub_task(active:, overdue: false, scheduled_at: Time.zone.now, str: "")
    instance_double(NurseTask,
                    scheduled_at: scheduled_at,
                    to_s: str,
                    active?: active,
                    due?: true,
                    overdue?: overdue)
  end

  describe "#active_tasks_list" do
    it "displays only active tasks" do
      tasks = [
        stub_task(active: true, str: "active 1"),
        stub_task(active: false)
      ]
      presenter = ParticipantSummaryPresenter.new(nil, tasks)

      expect(presenter.active_tasks_list).to eq "active 1"
    end

    it "displays tasks in order of scheduled_at timestamps" do
      tasks = [
        stub_task(scheduled_at: Time.zone.local(2019), str: "t3", active: true),
        stub_task(scheduled_at: Time.zone.local(2014), str: "t1", active: true),
        stub_task(scheduled_at: Time.zone.local(2015), str: "t2", active: true)
      ]
      presenter = ParticipantSummaryPresenter.new(nil, tasks)

      expect(presenter.active_tasks_list).to eq "t1, t2, t3"
    end
  end

  describe "#css_class" do
    it "marks summaries with no active tasks" do
      tasks = [
        stub_task(active: false, overdue: true),
        stub_task(active: false, overdue: false)
      ]

      presenter = ParticipantSummaryPresenter.new(nil, tasks)

      expect(presenter.css_class)
        .to eq ParticipantSummaryPresenter::CSS_CLASSES.no_tasks
    end

    it "marks summaries with overdue active tasks" do
      tasks = [
        stub_task(active: true, overdue: true),
        stub_task(active: false, overdue: true)
      ]

      presenter = ParticipantSummaryPresenter.new(nil, tasks)

      expect(presenter.css_class)
        .to eq ParticipantSummaryPresenter::CSS_CLASSES.overdue_tasks
    end

    it "marks summaries with current active tasks" do
      tasks = [
        stub_task(active: true, overdue: false),
        stub_task(active: false, overdue: true)
      ]

      presenter = ParticipantSummaryPresenter.new(nil, tasks)

      expect(presenter.css_class)
        .to eq ParticipantSummaryPresenter::CSS_CLASSES.current_tasks
    end
  end

  describe "#overdue_tasks" do
    def presented_tasks
      tasks = [
        stub_task(active: true, overdue: true),
        stub_task(active: false, overdue: true)
      ]

      ParticipantSummaryPresenter.new(nil, tasks)
    end

    it "includes only active tasks" do
      presented_tasks.overdue_tasks.each do |t|
        expect(t.active?).to be true
      end
    end
  end
end
