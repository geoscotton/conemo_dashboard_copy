# frozen_string_literal: true

require "spec_helper"

RSpec.describe "tasks/index", type: :view do
  let(:template) { "tasks/index" }

  it "renders the assigned task count" do
    assign(:tasks, double("tasks", count: 5, overdue: []))

    render template: template

    expect(rendered). to include "5 tasks"
  end

  it "renders the overdue task count" do
    assign(:tasks, double("tasks", count: 0, overdue: ["task 1", "task 2"]))

    render template: template

    expect(rendered). to include "2 overdue"
  end
end
