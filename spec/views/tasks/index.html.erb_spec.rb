# frozen_string_literal: true

require "rails_helper"

RSpec.describe "tasks/index", type: :view do
  let(:template) { "tasks/index" }
  let(:tasks) do
    double("Tasks",
           id: rand,
           study_identifier: "1234",
           tasks: [],
           all_tasks: [],
           tasks_count: rand,
           tasks_overdue: [])
  end

  it "renders a progress bar with all tasks" do
    assign(:tasks, tasks)
    completed_task = instance_double(NurseTask,
                                     to_s: "completed task 1",
                                     active?: false)
    allow(tasks).to receive(:tasks) { [completed_task] }

    render template: template

    expect(rendered). to include "completed task 1"
  end

  it "renders the participant study id" do
    assign(:tasks, tasks)

    render template: template

    expect(rendered). to include "Patient 1234"
  end

  it "renders the assigned active task count" do
    assign(:tasks, tasks)
    allow(tasks).to receive(:tasks_count) { 5 }

    render template: template

    expect(rendered). to include "5 tasks"
  end

  it "renders the overdue task count" do
    assign(:tasks, tasks)
    allow(tasks).to receive(:tasks_overdue) { ["task 1", "task 2"] }

    render template: template

    expect(rendered). to include "2 overdue"
  end

  it "renders the time before/until each task" do
    I18n.locale = "en"
    task = instance_double(NurseTask,
                           to_s: "Do fu",
                           scheduled_at: 1.minute.ago,
                           active?: true)
    assign(:tasks, tasks)
    allow(tasks).to receive(:tasks) { [task] }

    render template: template

    expect(rendered). to match(/Do fu .*1 minute/)
  end
end
