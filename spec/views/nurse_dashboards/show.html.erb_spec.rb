# frozen_string_literal: true

require "rails_helper"
require_relative "../../../app/models/nurse_task"
require_relative "../../../app/models/participant"

RSpec.describe "nurse_dashboards/show", type: :view do
  def stub_participant_summary(id, tasks_list)
    instance_double(
      ParticipantSummaryPresenter,
      css_class: "class#{id}",
      id: id,
      study_identifier: "ID #{id}",
      active_tasks_list: tasks_list,
      configuration_token: "token_#{id}",
      last_and_first_name: "last, first #{id}"
    )
  end

  let(:template) { "nurse_dashboards/show" }
  let(:participant1) { stub_participant_summary 1, "" }
  let(:participant2) { stub_participant_summary 2, "Walk without rhythm, Scat" }
  let(:participant3) { stub_participant_summary 3, "Hopscotch" }

  it "renders correctly when there are no participants" do
    I18n.locale = "en"
    assign(:nurse_dashboard, double("dashboard", participant_summaries: []))

    render template: template

    expect(rendered).to include "Your patients"
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
      dashboard = double("dashboard",
                         participant_summaries: [participant1,
                                                 participant2,
                                                 participant3])
      assign(:nurse_dashboard, dashboard)
      assign(:tasks, 2 => [current_task, overdue_task], 3 => [current_task])

      render template: template
    end

    it "renders the participant details" do
      assign_and_render

      table_exists_with_the_following_rows(
        [
          ["ID 1", "", "token_1"],
          ["ID 2", "Walk without rhythm, Scat", "token_2"],
          ["ID 3", "Hopscotch", "token_3"]
        ]
      )
    end

    it "renders rows with specified CSS class" do
      assign_and_render

      expect(rendered).to have_selector(".class1", text: "ID 1")
    end
  end
end
