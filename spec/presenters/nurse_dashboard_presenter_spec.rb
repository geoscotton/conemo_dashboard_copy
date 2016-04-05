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
      double("Participant", id: 4, to_i: 4, study_identifier: "middle"),
      double("Participant", id: 5, to_i: 5, study_identifier: "overdue1"),
      double("Participant", id: 6, to_i: 6, study_identifier: "overdue2")
    ]
  end
  let(:tasks) do
    [
      instance_double(NurseTask,
                      participant_id: 1,
                      scheduled_at: Time.zone.local(2018, 1, 1),
                      active?: true,
                      due?: true,
                      overdue?: false),
      instance_double(NurseTask,
                      participant_id: 2,
                      scheduled_at: Time.zone.local(2016, 1, 1),
                      active?: true,
                      due?: true,
                      overdue?: false),
      instance_double(NurseTask,
                      participant_id: 4,
                      scheduled_at: Time.zone.local(2017, 1, 1),
                      active?: true,
                      due?: true,
                      overdue?: false),
      instance_double(NurseTask,
                      participant_id: 5,
                      scheduled_at: Time.zone.local(2011, 1, 1),
                      overdue_at: Time.zone.local(2011, 2, 1),
                      active?: true,
                      due?: true,
                      overdue?: true),
      instance_double(NurseTask,
                      participant_id: 6,
                      scheduled_at: Time.zone.local(2011, 2, 1),
                      overdue_at: Time.zone.local(2011, 3, 1),
                      active?: true,
                      due?: true,
                      overdue?: true)
    ]
  end

  describe "#participant_summaries" do
    it "orders by oldest to newest task, then current participants" do
      allow(NurseTask).to receive(:where) { tasks }
      allow(nurse).to receive(:active_participants) { participants }

      participant_study_ids = NurseDashboardPresenter
                              .new(nurse)
                              .participant_summaries
                              .map { |s| s.participant.study_identifier }
      expect(participant_study_ids)
        .to eq %w( overdue1 overdue2 oldest middle newest no\ tasks )
    end
  end
end
