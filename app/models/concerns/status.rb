# frozen_string_literal: true
# Handles Participant overall and individual lesson status logic
module Status
  LESSON_STATUSES = Struct
                    .new(:unreleased, :accessed_incomplete, :completed_late,
                         :info, :danger, :completed_on_time)
                    .new("un-released", "warning", "slippage",
                         "info", "danger", "success")
                    .freeze

  # Lesson Status
  def lesson_status(lesson)
    if lesson_released?(lesson)
      access_status(lesson)
    else
      LESSON_STATUSES.unreleased
    end
  end

  def access_response(lesson)
    content_access_events.where(lesson_id: lesson.id).order(:created_at).first
  end

  private

  def lesson_released?(lesson)
    if lesson && study_day
      lesson.day_in_treatment <= study_day
    else
      false
    end
  end

  def first_session_access(lesson)
    session_events.where(lesson_id: lesson.id).order(:occurred_at).first
  end

  def access_status(lesson)
    access = first_session_access(lesson)
    completion = access_response(lesson)

    if lesson.guid == current_lesson.guid
      LESSON_STATUSES.info
    elsif access && !completion
      LESSON_STATUSES.accessed_incomplete
    # special case: training session == day 0
    elsif completion && lesson.day_in_treatment != 0 &&
          completion.accessed_at.to_date >=
          (start_date + next_lesson(lesson).day_in_treatment - 1)
      LESSON_STATUSES.completed_late
    elsif !completion && lesson_released?(next_lesson(lesson))
      LESSON_STATUSES.danger
    else
      LESSON_STATUSES.completed_on_time
    end
  end

  def next_lesson(lesson)
    Lesson.where("day_in_treatment > ?", lesson.day_in_treatment)
          .where(locale: locale)
          .order(day_in_treatment: :asc).first
  end

  # Overall Status
  def current_lesson
    Lesson.where("day_in_treatment <= ?", study_day)
          .where(locale: locale)
          .order(day_in_treatment: :desc).first
  end

  def one_lesson_ago
    Lesson.where("day_in_treatment <= ?", study_day)
          .where(locale: locale)
          .order(day_in_treatment: :desc).second
  end

  def two_lessons_ago
    Lesson.where("day_in_treatment <= ?", study_day)
          .where(locale: locale)
          .order(day_in_treatment: :desc).offset(2).first
  end

  def two_lessons_ago_complete?
    return unless two_lessons_ago

    two_lessons_ago.content_access_events.where(participant_id: id).any?
  end

  def one_lesson_ago_complete?
    return unless one_lesson_ago

    one_lesson_ago.content_access_events.where(participant_id: id).any?
  end
end
