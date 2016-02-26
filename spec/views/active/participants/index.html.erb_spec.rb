# frozen_string_literal: true
require "spec_helper"

RSpec.describe "active/participants/index", type: :view do
  let(:template) { "active/participants/index.html.erb" }
  let(:help_messages) { double("help messages").as_null_object }
  let(:participant) do
    instance_double(Participant, help_messages: help_messages).as_null_object
  end
  let(:admin) { instance_double(User, admin?: true).as_null_object }

  context "when a configuration token exists" do
    it "is displayed for the participant" do
      assign(:participants, [participant])
      allow(view).to receive(:token_for).with(participant) { "abc" }

      render template: template,
             locals: { current_user: admin }

      expect(rendered).to have_selector("td", text: "abc")
    end
  end
end
