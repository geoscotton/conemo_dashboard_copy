# frozen_string_literal: true
require "rails_helper"

RSpec.describe ParticipantsHelper, type: :helper do
  describe "#study_status" do
    it "returns the appropriate study status class" do
      {
        "stable" => "green",
        "warning" => "yellow",
        "danger" => "red",
        "none" => "none"
      }.each do |status, css_class|
        participant = instance_double(Participant, current_study_status: status)

        expect(helper.study_status(participant)).to eq css_class
      end
    end
  end
end
