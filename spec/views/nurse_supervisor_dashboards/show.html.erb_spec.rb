# frozen_string_literal: true

require "rails_helper"

RSpec.describe "nurse_supervisor_dashboards/show", type: :view do
  def stub_participant(id, name)
    instance_double(
      Participant,
      id: id,
      study_identifier: "ID #{id}",
      last_and_first_name: name,
      enrollment_date: date,
      created_at: time
    )
  end

  let(:template) { "nurse_supervisor_dashboards/show" }
  let!(:locale) do
    I18n.locale = LOCALES.values.sample

    I18n.locale
  end
  let(:date) { Time.zone.today }
  let(:time) { Time.zone.now }
  let(:date_str) { I18n.l date, format: :long }

  it "renders correctly when there are no participants or nurses" do
    assign(:pending_participants, [])
    assign(:nurses, [])

    render template: template

    expect(rendered).to include "0 Unassigned Participants"
  end

  context "when there are unassigned (pending) participants" do
    let(:pending1) { stub_participant 1, "Andy Abacus" }
    let(:pending2) { stub_participant 2, "Billy Ball" }

    def assign_pending_and_render
      assign(:pending_participants, [pending1, pending2])
      assign(:nurses, [])

      render template: template
    end

    it "renders the participant count" do
      assign_pending_and_render

      expect(rendered).to include "2 Unassigned Participants"
    end

    it "renders the participant details" do
      assign_pending_and_render

      table_exists_with_the_following_rows(
        [
          [
            I18n.t("conemo.views.pending.participants.index.edit_info"),
            "Andy Abacus", "ID 1", date_str, date_str,
            I18n.t("conemo.views.pending.participants.index.activate"),
            I18n.t("conemo.views.pending.participants.index.disqualify")
          ],
          [
            I18n.t("conemo.views.pending.participants.index.edit_info"),
            "Billy Ball", "ID 2", date_str, date_str,
            I18n.t("conemo.views.pending.participants.index.activate"),
            I18n.t("conemo.views.pending.participants.index.disqualify")
          ]
        ]
      )
    end
  end

  context "when there are assigned nurses" do
    let(:nurse1) do
      nurse = instance_double(Nurse,
                              last_and_first_name: "Last 1, Nurse 1",
                              family_health_unit_name: "Unit 1")
      allow(nurse).to receive_message_chain("active_participants.count") { 314 }
      allow(nurse).to receive_message_chain("active_tasks.count") { 425 }
      allow(nurse).to receive_message_chain("overdue_tasks.count") { 536 }

      nurse
    end
    let(:nurse2) do
      nurse = instance_double(Nurse,
                              last_and_first_name: "Last 2, Nurse 2",
                              family_health_unit_name: "Unit 2")
      allow(nurse).to receive_message_chain("active_participants.count") { 987 }
      allow(nurse).to receive_message_chain("active_tasks.count") { 876 }
      allow(nurse).to receive_message_chain("overdue_tasks.count") { 765 }

      nurse
    end
    def assign_nurses_and_render
      I18n.locale = "en"
      assign(:pending_participants, [])
      assign(:nurses, [nurse1, nurse2])

      render template: template
    end

    it "renders the nurse names" do
      assign_nurses_and_render

      expect(rendered).to include "Last 1, Nurse 1"
      expect(rendered).to include "Last 2, Nurse 2"
    end

    it "renders the active patient count for each nurse" do
      assign_nurses_and_render

      expect(rendered).to include "314 Participants"
      expect(rendered).to include "987 Participants"
    end

    it "renders the active task count for each nurse" do
      assign_nurses_and_render

      expect(rendered).to include "425 Tasks"
      expect(rendered).to include "876 Tasks"
    end

    it "renders the overdue task count for each nurse" do
      assign_nurses_and_render

      expect(rendered).to include "536 Overdue"
      expect(rendered).to include "765 Overdue"
    end

    it "renders the family health unit for each nurse" do
      assign_nurses_and_render

      expect(rendered).to include "Unit 1"
      expect(rendered).to include "Unit 2"
    end
  end
end
