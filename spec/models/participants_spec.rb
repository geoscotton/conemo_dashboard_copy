require "spec_helper"

describe Participant do
  fixtures :all

  let(:participant) { participants(:participant1)}

  describe "#sanitize_number" do
    it "strips non-numeric characters" do
      participant.phone = "(444)555-5555"
      participant.save
      expect(participant.phone).to eq "4445555555"
    end
  end

  describe "synchronizable resource creation" do
    it "creates a Device resource" do
      expect { participant.save }.to change {
        TokenAuth::SynchronizableResource.where(class_name: Device.name).count
      }.by(1)
    end

    it "creates a HelpMessage resource" do
      expect { participant.save }.to change {
        TokenAuth::SynchronizableResource.where(
          class_name: HelpMessage.name
        ).count
      }.by(1)
    end

    it "creates a ParticipantStartDate resource" do
      expect { participant.save }.to change {
        TokenAuth::SynchronizableResource.where(
          class_name: ParticipantStartDate.name
        ).count
      }.by(1)
    end
  end

  describe "Overall Study Status" do
    let(:participant_day_5) { participants(:active_participant_day_5) }
    let(:two_lessons_ago) { lessons(:day2) }
    let(:one_lesson_ago) { lessons(:day4) }
    let(:current_lesson) { lessons(:day5) }

    before :each do
      @content_access_event_for_two_lessons_ago = ContentAccessEvent.create!(
        participant: participant_day_5,
        day_in_treatment_accessed: two_lessons_ago.day_in_treatment,
        lesson: two_lessons_ago,
        accessed_at: Time.zone.now
      )

      @content_access_event_for_one_lesson_ago = ContentAccessEvent.create!(
        participant: participant_day_5,
        day_in_treatment_accessed: one_lesson_ago.day_in_treatment,
        lesson: one_lesson_ago,
        accessed_at: Time.zone.now
      )
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

    describe "#lesson_status(lesson)" do
      let(:unreleased_lesson) { lessons(:day6) }
      let(:missed_lesson) { lessons(:day2) }
      let(:current_lesson) { lessons(:day5) }
      let(:late_lesson) { lessons(:day4) }
      let(:on_time_lesson) { lessons(:day4) }

      context "lesson day in treatment is greater than current day" do
        it "should return 'un-released'" do
          result = participant_day_5.lesson_status(unreleased_lesson)

          expect(result).to eq Status::LESSON_STATUSES.unreleased
        end
      end

      context "lesson has not been accessed and next lesson has been released" do
        it "should return 'danger'" do
          result = participant_day_5.lesson_status(missed_lesson)

          expect(result).to eq Status::LESSON_STATUSES.danger
        end
      end

      context "lesson has not been accessed but next lesson has not been released" do
        it "should return 'info'" do
          result = participant_day_5.lesson_status(current_lesson)

          expect(result).to eq Status::LESSON_STATUSES.info
        end
      end

      context "lesson has been accessed but it was late" do
        it "should return 'warning'" do
          SessionEvent.create!(
            event_type: SessionEvent::TYPES.access,
            participant_id: participant_day_5.id,
            occurred_at: participant_day_5.start_date + 10.days,
            lesson_id: late_lesson.id)

          result = participant_day_5.lesson_status(late_lesson)

          expect(result).to eq Status::LESSON_STATUSES.warning
        end
      end

      context "lesson was accessed on time" do
        it "should return 'success'" do
          ContentAccessEvent.create!(
            participant: participant_day_5,
            day_in_treatment_accessed: on_time_lesson.day_in_treatment,
            lesson: on_time_lesson,
            accessed_at: Time.zone.now
          )

          result = participant_day_5.lesson_status(on_time_lesson)

          expect(result).to eq Status::LESSON_STATUSES.success
        end
      end
    end
  end
end
