# frozen_string_literal: true

require "spec_helper"

RSpec.describe "tasks/index", type: :view do
  let(:template) { "tasks/index" }
  let(:tasks) do
    double("Tasks",
           id: rand,
           study_identifier: "1234",
           tasks: [],
           tasks_count: rand,
           tasks_overdue: [])
  end

  it "renders the participant study id" do
    assign(:tasks, tasks)

    render template: template

    expect(rendered). to include "Patient 1234"
  end

  it "renders the assigned task count" do
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
    task = instance_double(NurseTask, to_s: "Do fu", scheduled_at: 1.minute.ago)
    assign(:tasks, tasks)
    allow(tasks).to receive(:tasks) { [task] }

    render template: template

    expect(rendered). to match(/Do fu .*1 minute/)
  end
end
