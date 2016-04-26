# frozen_string_literal: true
require "rails_helper"

RSpec.describe "participants/edit", type: :view do
  let(:participant) { Participant.new }

  context "for Nurses" do
    def stub_nurse
      nurse = instance_double(User, nurse?: true)
      allow(view).to receive(:current_user) { nurse }
    end

    it "renders disabled study_identifier input" do
      stub_nurse
      assign(:participant, participant)

      render template: "participants/edit"

      expect(rendered).to have_xpath(
        "//input[@name='participant[study_identifier]' and " \
          "@disabled='disabled']"
      )
    end

    it "renders disabled family_health_unit_name input" do
      stub_nurse
      assign(:participant, participant)

      render template: "participants/edit"

      expect(rendered).to have_xpath(
        "//input[@name='participant[family_health_unit_name]' and " \
          "@disabled='disabled']"
      )
    end
  end

  context "for Nurse Supervisors" do
    def stub_nurse_supervisor
      supervisor = instance_double(User, nurse?: false)
      allow(view).to receive(:current_user) { supervisor }
    end

    it "renders enabled study_identifier input" do
      stub_nurse_supervisor
      assign(:participant, participant)

      render template: "participants/edit"

      expect(rendered).to have_xpath(
        "//input[@name='participant[study_identifier]' and " \
          "not(@disabled='disabled')]"
      )
    end

    it "renders enabled family_health_unit_name input" do
      stub_nurse_supervisor
      assign(:participant, participant)

      render template: "participants/edit"

      expect(rendered).to have_xpath(
        "//select[@name='participant[family_health_unit_name]' and " \
          "not(@disabled='disabled')]"
      )
    end
  end
end
