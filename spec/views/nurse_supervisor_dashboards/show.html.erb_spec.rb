# frozen_string_literal: true

require "rails_helper"

RSpec.describe "nurse_supervisor_dashboards/show", type: :view do
  def stub_participant(id, name, nurse: nil)
    instance_double(
      Participant,
      id: id,
      study_identifier: "ID #{id}",
      last_and_first_name: name,
      enrollment_date: date,
      created_at: time,
      nurse: nurse
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
  let(:nurse1) do
    instance_double(Nurse,
                    last_and_first_name: "Nurse 1",
                    cancelled_tasks: [],
                    rescheduled_tasks: [])
  end
  let(:nurse2) do
    instance_double(Nurse,
                    last_and_first_name: "Nurse 2",
                    cancelled_tasks: [],
                    rescheduled_tasks: [])
  end

  it "renders correctly when there are no participants or nurses" do
    assign(:pending_participants, [])
    assign(:active_participants, [])
    assign(:completed_participants, [])
    assign(:dropped_out_participants, [])
    assign(:nurses, [])

    render template: template

    expect(rendered).to include "0 Pending"
  end

  context "when there are unassigned (pending) participants" do
    let(:pending1) { stub_participant 1, "Andy Abacus" }
    let(:pending2) { stub_participant 2, "Billy Ball" }

    def assign_pending_and_render
      assign(:pending_participants, [pending1, pending2])
      assign(:active_participants, [])
      assign(:completed_participants, [])
      assign(:dropped_out_participants, [])
      assign(:nurses, [])

      render template: template
    end

    it "renders the participant count" do
      assign_pending_and_render

      expect(rendered).to include "2 Pending"
    end

    it "renders the participant details" do
      assign_pending_and_render

      table_exists_with_the_following_rows(
        [
          [
            I18n.t("conemo.views.pending.participants.index.edit_info"),
            "Andy Abacus", "ID 1", date_str, date_str,
            I18n.t("conemo.views.pending.participants.index.activate")
          ],
          [
            I18n.t("conemo.views.pending.participants.index.edit_info"),
            "Billy Ball", "ID 2", date_str, date_str,
            I18n.t("conemo.views.pending.participants.index.activate")
          ]
        ]
      )
    end
  end

  context "when there are active participants" do
    let(:active1) { stub_participant 1, "Andy Abacus", nurse: nurse1 }
    let(:active2) { stub_participant 2, "Billy Ball", nurse: nurse2 }

    def assign_active_and_render
      assign(:pending_participants, [])
      assign(:active_participants, [active1, active2])
      assign(:completed_participants, [])
      assign(:dropped_out_participants, [])
      assign(:nurses, [])

      render template: template
    end

    it "renders the participant count" do
      assign_active_and_render

      expect(rendered).to include "2 Active"
    end

    it "renders the participant details" do
      assign_active_and_render

      table_exists_with_the_following_rows(
        [
          [
            I18n.t("conemo.views.pending.participants.index.edit_info"),
            "Nurse 1", "Andy Abacus", "ID 1", date_str, date_str,
            I18n.t("conemo.views.pending.participants.index.disqualify")
          ],
          [
            I18n.t("conemo.views.pending.participants.index.edit_info"),
            "Nurse 2", "Billy Ball", "ID 2", date_str, date_str,
            I18n.t("conemo.views.pending.participants.index.disqualify")
          ]
        ]
      )
    end
  end

  context "when there are completed participants" do
    let(:completed1) { stub_participant 1, "Cory Caper", nurse: nurse1 }
    let(:completed2) { stub_participant 2, "Diggory Dapper", nurse: nurse2 }

    def assign_completed_and_render
      assign(:pending_participants, [])
      assign(:active_participants, [])
      assign(:completed_participants, [completed1, completed2])
      assign(:dropped_out_participants, [])
      assign(:nurses, [])

      render template: template
    end

    it "renders the participant count" do
      assign_completed_and_render

      expect(rendered).to include "2 Completed"
    end

    it "renders the participant details" do
      assign_completed_and_render

      table_exists_with_the_following_rows(
        [
          ["Nurse 1", "Cory Caper", "ID 1", date_str, date_str],
          ["Nurse 2", "Diggory Dapper", "ID 2", date_str, date_str]
        ]
      )
    end
  end

  context "when there are dropped out participants" do
    let(:dropped_out1) { stub_participant 1, "Cory Caper", nurse: nurse1 }
    let(:dropped_out2) { stub_participant 2, "Diggory Dapper", nurse: nurse2 }

    def assign_dropped_out_and_render
      assign(:pending_participants, [])
      assign(:active_participants, [])
      assign(:completed_participants, [])
      assign(:dropped_out_participants, [dropped_out1, dropped_out2])
      assign(:nurses, [])

      render template: template
    end

    it "renders the participant count" do
      assign_dropped_out_and_render

      expect(rendered).to include "2 Dropped out"
    end

    it "renders the participant details" do
      assign_dropped_out_and_render

      table_exists_with_the_following_rows(
        [
          ["Cory Caper", "ID 1", date_str],
          ["Diggory Dapper", "ID 2", date_str]
        ]
      )
    end
  end

  context "when there are assigned nurses" do
    let(:sessions1) { double("sessions").as_null_object }
    let(:nurse1) do
      instance_double(Nurse,
                      active_participants: [],
                      current_tasks: [],
                      overdue_tasks: [],
                      active_tasks: [],
                      cancelled_tasks: [],
                      rescheduled_tasks: [],
                      supervision_sessions: sessions1).as_null_object
    end
    let(:sessions2) { double("sessions").as_null_object }
    let(:nurse2) do
      instance_double(Nurse,
                      active_participants: [],
                      current_tasks: [],
                      overdue_tasks: [],
                      active_tasks: [],
                      cancelled_tasks: [],
                      rescheduled_tasks: [],
                      supervision_sessions: sessions2).as_null_object
    end

    def assign_nurses_and_render
      I18n.locale = "en"
      assign(:pending_participants, [])
      assign(:active_participants, [])
      assign(:completed_participants, [])
      assign(:dropped_out_participants, [])
      assign(:nurses, [nurse1, nurse2])

      render template: template
    end

    it "renders the nurse names" do
      allow(nurse1).to receive(:last_and_first_name) { "Last 1, Nurse 1" }
      allow(nurse2).to receive(:last_and_first_name) { "Last 2, Nurse 2" }
      assign_nurses_and_render

      expect(rendered).to include "Last 1, Nurse 1"
      expect(rendered).to include "Last 2, Nurse 2"
    end

    it "renders the active patient count for each nurse" do
      allow(nurse1).to receive_message_chain("active_participants.count")
        .and_return(314)
      allow(nurse2).to receive_message_chain("active_participants.count")
        .and_return(987)
      assign_nurses_and_render

      expect(rendered).to include "314 Participants"
      expect(rendered).to include "987 Participants"
    end

    it "renders the current task count for each nurse" do
      allow(nurse1).to receive_message_chain("current_tasks.count") { 425 }
      allow(nurse2).to receive_message_chain("current_tasks.count") { 876 }
      assign_nurses_and_render

      expect(rendered).to include "425 Tasks"
      expect(rendered).to include "876 Tasks"
    end

    it "renders the overdue task count for each nurse" do
      allow(nurse1).to receive_message_chain("overdue_tasks.count") { 536 }
      allow(nurse2).to receive_message_chain("overdue_tasks.count") { 765 }
      assign_nurses_and_render

      expect(rendered).to include "536 Overdue"
      expect(rendered).to include "765 Overdue"
    end

    it "renders the family health unit for each nurse" do
      allow(nurse1).to receive(:family_health_unit_name) { "Unit 1" }
      allow(nurse2).to receive(:family_health_unit_name) { "Unit 2" }
      assign_nurses_and_render

      expect(rendered).to include "Unit 1"
      expect(rendered).to include "Unit 2"
    end
  end
end
