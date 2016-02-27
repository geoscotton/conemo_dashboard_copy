# frozen_string_literal: true
require "rails_helper"

class MockTask < NurseTask
  OVERDUE_AFTER_DAYS = 5
end

RSpec.describe NurseTask, type: :model do
  fixtures :users

  describe "initialization" do
    describe "setting the overdue timestamp" do
      let(:nurse) { Nurse.all.sample }

      it "is set correctly based on the OVERDUE_AFTER_DAYS" do
        [
          [[2015, 10, 6, 8], [2015, 10, 14, 0]],
          [[2015, 10, 6, 13], [2015, 10, 15, 0]],
          [[2015, 10, 9, 11], [2015, 10, 19, 0]],
          [[2015, 10, 9, 23], [2015, 10, 20, 0]]
        ].each do |dates|
          scheduled_at = overdue_at = nil
          Time.use_zone(nurse.timezone) do
            scheduled_at = Time.zone.local(*dates[0])
            overdue_at = Time.zone.local(*dates[1])
          end
          task = MockTask.new(nurse: nurse, scheduled_at: scheduled_at)
                         .tap(&:valid?)

          expect(task.overdue_at).to eq overdue_at
        end
      end
    end
  end
end
