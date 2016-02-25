# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/models/nurse_task"
require_relative "../../../app/models/participant"

RSpec.describe "nurse_dashboards/show", type: :view do
  def stub_participant(id)
    instance_double(
      Participant,
      id: id,
      study_identifier: "ID #{id}"
    )
  end

  let(:template) { "nurse_dashboards/show" }
  let(:participant1) { stub_participant 1 }
  let(:participant2) { stub_participant 2 }
  let(:participant3) { stub_participant 3 }

  it "renders correctly when there are no participants" do
    assign(:participants, [])

    render template: template

    expect(rendered).to include "Your Patients"
  end

  context "when there are participants" do
    let(:current_task) do
      instance_double(NurseTask,
                      to_s: "Walk without rhythm",
                      overdue?: false)
    end
    let(:overdue_task) do
      instance_double(NurseTask,
                      to_s: "Scat",
                      overdue?: true)
    end

    def assign_and_render
      assign(:participants, [participant1, participant2, participant3])
      assign(:tasks, 2 => [current_task, overdue_task], 3 => [current_task])

      render template: template
    end

    it "renders the participant details" do
      assign_and_render

      table_exists_with_the_following_rows(
        [
          ["ID 1", ""],
          ["ID 2", "Walk without rhythm, Scat"],
          ["ID 3", "Walk without rhythm"]
        ]
      )
    end

    it "renders success rows for no tasks" do
      assign_and_render

      expect(rendered).to have_selector(".success", text: "ID 1")
    end

    it "renders warning rows for current tasks" do
      assign_and_render

      expect(rendered).to have_selector(".danger", text: "ID 2")
    end

    it "renders danger rows for overdue tasks" do
      assign_and_render

      expect(rendered).to have_selector(".warning", text: "ID 3")
    end
  end
end
