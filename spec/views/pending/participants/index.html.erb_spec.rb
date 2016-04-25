# frozen_string_literal: true

require "rails_helper"

RSpec.describe "pending/participants/index", type: :view do
  TEMPLATE_PATH = "pending/participants/index"

  def stub_instance_variables
    assign(:unassigned_participants, [])
    assign(:ineligible_participants, [])
  end

  context "when the current user is authorized" do
    it "displays the new participant link" do
      stub_instance_variables

      allow(view).to receive(:can?).with(:create, Participant) { true }
      render template: TEMPLATE_PATH

      text = t("pending.participants.index.add_new_participant")
      expect(rendered).to include text
    end
  end

  context "when the current user is unauthorized" do
    it "does not display the new participant link" do
      stub_instance_variables

      allow(view).to receive(:can?).with(:create, Participant) { false }
      render template: TEMPLATE_PATH

      text = t("pending.participants.index.add_new_participant")
      expect(rendered).not_to include text
    end
  end
end
