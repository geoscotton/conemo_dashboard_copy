# frozen_string_literal: true
require "rails_helper"

RSpec.describe TaskPresenter do
  describe "#css_class" do
    let(:future_task) do
      TaskPresenter.new(
        instance_double(NurseTask,
                        active?: true,
                        scheduled_at: Time.zone.now + 1.day)
      )
    end
    let(:overdue_task) do
      TaskPresenter.new(
        instance_double(NurseTask,
                        active?: true,
                        scheduled_at: Time.zone.now - 1.day,
                        overdue?: true)
      )
    end
    let(:active_task) do
      TaskPresenter.new(
        instance_double(NurseTask,
                        active?: true,
                        scheduled_at: Time.zone.now - 1.day,
                        overdue?: false)
      )
    end
    let(:resolved_task) do
      TaskPresenter.new(
        instance_double(NurseTask,
                        active?: false,
                        resolved?: true)
      )
    end
    let(:cancelled_task) do
      TaskPresenter.new(
        instance_double(NurseTask,
                        active?: false,
                        resolved?: false,
                        cancelled?: true)
      )
    end

    it "is based on scheduled time and status" do
      expect(future_task.css_class).to eq TaskPresenter::CSS_CLASSES.future
      expect(overdue_task.css_class).to eq TaskPresenter::CSS_CLASSES.overdue
      expect(active_task.css_class).to eq TaskPresenter::CSS_CLASSES.active
      expect(resolved_task.css_class).to eq TaskPresenter::CSS_CLASSES.resolved
      expect(cancelled_task.css_class)
        .to eq TaskPresenter::CSS_CLASSES.cancelled
    end
  end
end
