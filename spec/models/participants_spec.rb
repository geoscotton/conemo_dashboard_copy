require "spec_helper"

describe Participant do
  fixtures :participants, :lessons

  describe "#sanitize_number" do
  end

  describe "Overall Study Status" do
    let(:participant_day_5) { participants(:active_participant_day_5) }
    let(:two_lessons_ago) { lessons(:day2) }
    let(:one_lesson_ago) { lessons(:day4) }
    let(:current_lesson) { lessons(:day5) }

    describe "#one_lesson_ago" do
      it "should return the previous lesson" do
        result = participant_day_5.one_lesson_ago
        expect(result).to eq one_lesson_ago
      end
    end

    describe "#two_lessons_ago" do
      it "should return the previous lesson" do
        result = participant_day_5.two_lessons_ago
        expect(result).to eq two_lessons_ago
      end
    end

    before :each do
      @content_access_event_for_two_lessons_ago = ContentAccessEvent.create(participant_id: participant_day_5.id,
                                                                            day_in_treatment_accessed: two_lessons_ago.day_in_treatment,
                                                                            lesson_id: two_lessons_ago.id
                                                                           )

      @content_access_event_for_one_lesson_ago = ContentAccessEvent.create(participant_id: participant_day_5.id,
                                                                           day_in_treatment_accessed: one_lesson_ago.day_in_treatment,
                                                                           lesson_id: one_lesson_ago.id
                                                                          )
    end

    describe "#two_lessons_ago_complete?" do
      context "the previous lesson was complete" do
        it "should return true" do
          result = participant_day_5.two_lessons_ago_complete?
          expect(result).to eq true
        end
      end

      context "the previous lesson is incomplete" do
        it "should return false" do
          @content_access_event_for_two_lessons_ago.destroy
          result = participant_day_5.two_lessons_ago_complete?
          expect(result).to eq false
        end
      end
    end

    describe "#one_lesson_ago_complete?" do
      context "the current lesson is complete" do
        it "should return true" do
          result = participant_day_5.one_lesson_ago_complete?
          expect(result).to eq true
        end
      end

      context "the current lesson is incomplete" do
        it "should return false" do
          @content_access_event_for_one_lesson_ago.destroy
          result = participant_day_5.one_lesson_ago_complete?
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
          @content_access_event_for_two_lessons_ago.destroy
          result = participant_day_5.current_study_status
          expect(result).to eq "warning"
        end
      end

      context "previous and current lesson have not been accessed" do
        it "should return 'danger'" do
          @content_access_event_for_one_lesson_ago.destroy
          @content_access_event_for_two_lessons_ago.destroy
          result = participant_day_5.current_study_status
          expect(result).to eq "danger"
        end
      end
    end
  end

  describe "Lesson Status" do
    let(:participant_day_5) { participants(:active_participant_day_5) }

    describe "#next_lesson" do
      let(:next_lesson) { lessons(:day5) }
      let(:current_lesson) { lessons(:day4) }

      it "should return the next lesson" do
        result = participant_day_5.next_lesson(current_lesson)
        expect(result).to eq next_lesson
      end
    end

    describe "#lesson_released(lesson)" do
      context "lesson day in treatment is greater than current day" do
        let(:unreleased_lesson) { lessons(:day6) }

        it "should return false" do
          result = participant_day_5.lesson_released?(unreleased_lesson)
          expect(result).to eq false
        end
      end

      context "lesson day in treatment is not greater than current day" do
        let(:released_lesson) { lessons(:day4) }

        it "should return true" do
          result = participant_day_5.lesson_released?(released_lesson)
          expect(result).to eq true
        end
      end
    end

    describe "#access_status(lesson)" do
      let(:missed_lesson) { lessons(:day2) }
      let(:current_lesson) { lessons(:day5) }
      let(:late_lesson) { lessons(:day4) }
      let(:on_time_lesson) { lessons(:day4) }

      context "lesson has not been accessed and next lesson has been released" do
        it "should return 'danger'" do
          result = participant_day_5.access_status(missed_lesson)
          expect(result).to eq "danger"
        end
      end

      context "lesson has not been accessed but next lesson has not been released" do
        it "should return 'info'" do
          result = participant_day_5.access_status(current_lesson)
          expect(result).to eq "info"
        end
      end

      context "lesson has been accessed but it was late" do
        it "should return 'warning'" do
          ContentAccessEvent.create(participant_id: participant_day_5.id,
                                    day_in_treatment_accessed: 5,
                                    lesson_id: late_lesson.id
                                   )
          result = participant_day_5.access_status(late_lesson)
          expect(result).to eq "warning"
        end
      end

      context "lesson was accessed on time" do
        it "should return 'success'" do
          ContentAccessEvent.create(participant_id: participant_day_5.id,
                                    day_in_treatment_accessed: on_time_lesson.day_in_treatment,
                                    lesson_id: on_time_lesson.id
                                   )
          result = participant_day_5.access_status(on_time_lesson)
          expect(result).to eq "success"
        end
      end
    end
  end
end