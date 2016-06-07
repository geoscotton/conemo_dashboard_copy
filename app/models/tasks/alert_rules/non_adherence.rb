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
            elsif !threshold_lessons_missed?(participant)
              delete_active(participant)
            end
          end
        end

        def triggered?(participant)
          participant.nurse.present? &&
            threshold_lessons_missed?(participant) &&
            !connectivity_alert_exists?(participant) &&
            !recently_resolved_task_exists?(participant)
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
          if available_lessons(participant).count <= THRESHOLD_LESSONS_MISSED
            return false
          end

          previous_lessons(available_lessons(participant)).all? do |lesson|
            participant.lesson_status(lesson) ==
              Participant::LESSON_STATUSES.danger
          end
        end

        def previous_lessons(lessons)
          lessons
            .to_a[-(THRESHOLD_LESSONS_MISSED + 1), THRESHOLD_LESSONS_MISSED]
        end

        def connectivity_alert_exists?(participant)
          Tasks::LackOfConnectivityCall.active.exists?(participant: participant)
        end

        def available_lessons(participant)
          Lesson.available_for(participant).order(:day_in_treatment)
        end

        def recently_resolved_task_exists?(participant)
          task = Tasks::NonAdherenceCall
                 .resolved
                 .where(participant: participant)
                 .order(:updated_at)
                 .last

          return false unless task.present?

          participant.study_day(on: task.updated_at.to_date) >=
            available_lessons(participant).last.day_in_treatment
        end
      end
    end
  end
end
