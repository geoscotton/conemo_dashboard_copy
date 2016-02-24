# frozen_string_literal: true

require "spec_helper"

RSpec.describe "tasks/index", type: :view do
  let(:template) { "tasks/index" }

  def assign_participant
    assign(:participant, double("Participant", study_identifier: "1234"))
  end

  it "renders the participant study id" do
    assign_participant
    assign(:tasks, double("tasks", count: 0, overdue: []))

    render template: template

    expect(rendered). to include "Patient 1234"
  end

  it "renders the assigned task count" do
    assign_participant
    assign(:tasks, double("tasks", count: 5, overdue: []))

    render template: template

    expect(rendered). to include "5 tasks"
  end

  it "renders the overdue task count" do
    assign_participant
    assign(:tasks, double("tasks", count: 0, overdue: ["task 1", "task 2"]))

    render template: template

    expect(rendered). to include "2 overdue"
  end
end
