# frozen_string_literal: true
require "rails_helper"

module Tasks
  RSpec.describe LackOfConnectivityCall, type: :model do
    fixtures :users, :participants

    let(:locale) { LOCALES.values.sample }
    let(:participant) do
      Participant.where.not(nurse: nil).find_by(locale: locale)
    end
    let(:nurse) { participant.nurse }

    describe "validation" do
      it "permits multiple resolved tasks" do
        LackOfConnectivityCall.create!(
          nurse: nurse,
          participant: participant,
          status: NurseTask::STATUSES.resolved
        )

        dup_task = LackOfConnectivityCall.new(
          nurse: nurse,
          participant: participant,
          status: NurseTask::STATUSES.resolved
        )

        expect(dup_task.valid?).to be true
      end

      it "doesn't permit more than one active task" do
        LackOfConnectivityCall.create!(
          nurse: nurse,
          participant: participant,
          status: NurseTask::STATUSES.active
        )

        dup_task = LackOfConnectivityCall.new(
          nurse: nurse,
          participant: participant,
          status: NurseTask::STATUSES.active
        )

        expect(dup_task.valid?).to be false
      end
    end
  end
end
