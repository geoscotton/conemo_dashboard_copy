require "spec_helper"

describe Participant do
  fixtures :participants, :lessons

  describe "Overall Study Status" do
    let(:participant_day_5) { participants(:active_participant_day_5) }
    let(:previous_lesson) { lessons(:day2) }
    let(:current_lesson) { lessons(:day4) }

    describe "#current_lesson" do
      it "should return the current lesson" do
        result = participant_day_5.current_lesson
        expect(result).to eq current_lesson
      end
    end

    describe "#previous_lesson" do
      it "should return the previous lesson" do
        result = participant_day_5.previous_lesson
        expect(result).to eq previous_lesson
      end
    end

    before :each do
      @content_access_event_for_previous_lesson = ContentAccessEvent.create(participant_id: participant_day_5.id,
                                                                            day_in_treatment_accessed: previous_lesson.day_in_treatment,
                                                                            lesson_id: previous_lesson.id
                                                                           )

      @content_access_event_for_current_lesson = ContentAccessEvent.create(participant_id: participant_day_5.id,
                                                                           day_in_treatment_accessed: current_lesson.day_in_treatment,
                                                                           lesson_id: current_lesson.id
                                                                          )
    end

    describe "#previous_lesson_complete?" do
      context "the previous lesson was complete" do
        it "should return true" do
          result = participant_day_5.previous_lesson_complete?
          expect(result).to eq true
        end
      end

      context "the previous lesson is incomplete" do
        it "should return false" do
          @content_access_event_for_previous_lesson.destroy
          result = participant_day_5.previous_lesson_complete?
          expect(result).to eq false
        end
      end
    end

    describe "#current_lesson_complete?" do
      context "the current lesson is complete" do
        it "should return true" do
          result = participant_day_5.current_lesson_complete?
          expect(result).to eq true
        end
      end

      context "the current lesson is incomplete" do
        it "should return false" do
          @content_access_event_for_current_lesson.destroy
          result = participant_day_5.current_lesson_complete?
          expect(result).to eq false
        end
      end
    end

    describe "#current_study_status" do
      context "previous and current lesson have been accessed" do
        it "should return 'stable'" do
          result = participant_day_5.current_study_status
          expect(result).to eq "stable"
        end
      end

      context "previous lesson has not been accessed" do
        it "should return 'warning'" do
          @content_access_event_for_previous_lesson.destroy
          result = participant_day_5.current_study_status
          expect(result).to eq "warning"
        end
      end

      context "previous and current lesson have not been accessed" do
        it "should return 'danger'" do
          @content_access_event_for_current_lesson.destroy
          @content_access_event_for_previous_lesson.destroy
          result = participant_day_5.current_study_status
          expect(result).to eq "danger"
        end
      end
    end
  end

  describe "Lesson Status" do
    describe "#next_lesson" do
      let(:next_lesson) { lessons(:day5) }
      let(:participant_day_5) { participants(:active_participant_day_5) }
      let(:current_lesson) { lessons(:day4) }

      it "should return the next lesson" do
        result = participant_day_5.next_lesson(current_lesson)
        expect(result).to eq next_lesson
      end
    end
  end
end