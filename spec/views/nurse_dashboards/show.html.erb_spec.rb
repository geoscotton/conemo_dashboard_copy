# frozen_string_literal: true

require "spec_helper"

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

  it "renders correctly when there are no participants" do
    assign(:participants, [])

    render template: template

    expect(rendered).to include "Your Patients"
  end

  context "when there are participants" do
    def assign_and_render
      assign(:participants, [participant1, participant2])
      assign(:tasks, 2 => ["Walk without rhythm", "Scat"])

      render template: template
    end

    it "renders the participant details" do
      assign_and_render

      table_exists_with_the_following_rows(
        [
          ["ID 1", ""],
          ["ID 2", "Walk without rhythm, Scat"]
        ]
      )
    end
  end
end
