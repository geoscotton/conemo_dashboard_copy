# frozen_string_literal: true

require "spec_helper"

RSpec.describe "nurse_supervisor_dashboards/show", type: :view do
  TEMPLATE = "nurse_supervisor_dashboards/show".freeze

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

  let(:pending1) { stub_participant 1, "Andy Abacus" }
  let(:pending2) { stub_participant 2, "Billy Ball" }
  let(:date) { Time.zone.today }
  let(:time) { Time.zone.now }
  let(:date_str) { I18n.l date, format: :long }

  it "renders correctly when there are no participants" do
    assign(:pending_participants, [])

    render template: TEMPLATE

    expect(rendered).to include "0 Unassigned Participants"
  end

  context "when there are unassigned (pending) participants" do
    def assign_pending_and_render
      assign(:pending_participants, [pending1, pending2])

      render template: TEMPLATE
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
            "Edit Information", "Andy Abacus", "ID 1", date_str, date_str,
            "Activate", "Disqualify"
          ],
          [
            "Edit Information", "Billy Ball", "ID 2", date_str, date_str,
            "Activate", "Disqualify"
          ]
        ]
      )
    end
  end
end
