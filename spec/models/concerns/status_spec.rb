require "spec_helper"

module Concerns
  class MockParticipant
    include Status

    attr_reader :study_day

    def initialize(study_day:)
      @study_day = study_day
    end
  end

  RSpec.describe Status do
    describe "#lesson_released?" do
      let(:started_participant) { MockParticipant.new(study_day: 3) }

      context "when the lesson is nil" do
        it "returns false" do
          expect(started_participant.lesson_released?(nil)).to eq false
        end
      end

      context "when the lesson will be available " \
              "after the current study day" do
        it "returns false" do
          lesson = instance_double(Lesson, day_in_treatment: 5)

          expect(started_participant.lesson_released?(lesson)).to eq false
        end
      end

      context "when the lesson is available " \
              "on the current study day" do
        it "returns true" do
          lesson =
            instance_double(Lesson,
                            day_in_treatment: started_participant.study_day)

          expect(started_participant.lesson_released?(lesson)).to eq true
        end
      end

      context "when the lesson exists and the study_day is nil" do
        it "returns false" do
          unstarted_participant = MockParticipant.new(study_day: nil)
          lesson = instance_double(Lesson, day_in_treatment: 5)

          expect(unstarted_participant.lesson_released?(lesson)).to eq false
        end
      end
    end
  end
end
