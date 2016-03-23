# frozen_string_literal: true
module Tasks
  module AlertRules
    # Determines when adherence has been missed and is alertable.
    module NonAdherence
      THRESHOLD_LESSONS_MISSED = 2

      class << self
        def create_tasks
          Participant.active.each do |participant|
            if triggered?(participant)
              report(participant)
            else
              delete_active(participant)
            end
          end
        end

        def triggered?(participant)
          participant.nurse.present? &&
            threshold_lessons_missed?(participant) &&
            !connectivity_alert_exists?(participant)
        end

        def report(participant)
          Tasks::NonAdherenceCall.create(
            participant: participant
          )
        end

        def delete_active(participant)
          Tasks::NonAdherenceCall
            .active
            .where(participant: participant)
            .map(&:soft_delete)
        end

        def threshold_lessons_missed?(participant)
          available_lessons = Lesson.available_for(participant)

          return false if available_lessons.count <= THRESHOLD_LESSONS_MISSED

          previous_lessons(available_lessons).all? do |lesson|
            participant.lesson_status(lesson) ==
              Participant::LESSON_STATUSES.danger
          end
        end

        def previous_lessons(available_lessons)
          available_lessons
            .order(:day_in_treatment)
            .to_a[-(THRESHOLD_LESSONS_MISSED + 1), THRESHOLD_LESSONS_MISSED]
        end

        def connectivity_alert_exists?(participant)
          Tasks::LackOfConnectivityCall.active.exists?(participant: participant)
        end
      end
    end
  end
end
