# frozen_string_literal: true
require "rails_helper"

module Tasks
  RSpec.describe HelpRequest, type: :model do
    fixtures :users, :participants

    let(:locale) { LOCALES.values.sample }
    let(:participant) do
      Participant.where.not(nurse: nil).find_by(locale: locale)
    end

    describe "validation" do
      it "permits multiple resolved tasks" do
        HelpRequest.create!(
          participant: participant,
          status: NurseTask::STATUSES.resolved
        )

        dup_task = HelpRequest.new(
          participant: participant,
          status: NurseTask::STATUSES.resolved
        )

        expect(dup_task.valid?).to be true
      end

      it "doesn't permit more than one active task" do
        HelpRequest.create!(
          participant: participant,
          status: NurseTask::STATUSES.active
        )

        dup_task = HelpRequest.new(
          participant: participant,
          status: NurseTask::STATUSES.active
        )

        expect(dup_task.valid?).to be false
      end
    end
  end
end
