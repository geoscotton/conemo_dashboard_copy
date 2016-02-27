# frozen_string_literal: true
require "rails_helper"

RSpec.describe NurseDashboardPresenter do
  fixtures :participants

  let(:nurse) { Nurse.all.sample }
  let(:participants) do
    [
      double("Participant", id: 1, to_i: 1, study_identifier: "newest"),
      double("Participant", id: 2, to_i: 2, study_identifier: "oldest"),
      double("Participant", id: 3, to_i: 3, study_identifier: "no tasks"),
      double("Participant", id: 4, to_i: 4, study_identifier: "middle")
    ]
  end
  let(:tasks) do
    [
      instance_double(NurseTask,
                      participant_id: 1,
                      scheduled_at: Time.zone.local(2018, 1, 1)),
      instance_double(NurseTask,
                      participant_id: 2,
                      scheduled_at: Time.zone.local(2016, 1, 1)),
      instance_double(NurseTask,
                      participant_id: 4,
                      scheduled_at: Time.zone.local(2017, 1, 1))
    ]
  end

  describe "#participant_summaries" do
    it "orders by oldest to newest task, then current participants" do
      allow(nurse).to receive(:active_tasks) { tasks }
      allow(nurse).to receive(:active_participants) { participants }

      participant_study_ids = NurseDashboardPresenter
                              .new(nurse)
                              .participant_summaries
                              .map { |s| s.participant.study_identifier }
      expect(participant_study_ids).to eq %w( oldest middle newest no\ tasks )
    end
  end
end
