# Handles Participant overall and individual lesson status logic
module Status
  extend ActiveSupport::Concern

  # Lesson Status
  def lesson_status(lesson)
    if lesson_released?(lesson)
      access_status(lesson)
    else
      "un-released"
    end
  end

  def lesson_released?(lesson)
    if lesson
      lesson.day_in_treatment <= study_day
    else
      false
    end
  end

  def access_status(lesson)
    access = content_access_events.where(lesson_id: lesson.id).first
    if !access && lesson_released?(next_lesson(lesson))
      "danger"
    elsif !access
      "info"
    elsif access.late?
      "warning"
    else
      "success"
    end
  end

  def next_lesson(lesson)
    Lesson.where("day_in_treatment >= ?", lesson.day_in_treatment)
          .order(day_in_treatment: :asc).first
  end

  # Overall Status
  def current_lesson
    Lesson.where("day_in_treatment <= ?", study_day)
          .where(locale: locale)
          .order(day_in_treatment: :desc).second
  end

  def previous_lesson
    Lesson.where("day_in_treatment <= ?", study_day)
          .where(locale: locale)
          .order(day_in_treatment: :desc).offset(2).first
  end

  def current_lesson_complete?
    if current_lesson
      current_lesson.content_access_events.where(participant_id: id).any?
    end
  end

  def previous_lesson_complete?
    if previous_lesson
      previous_lesson.content_access_events.where(participant_id: id).any?
    end
  end

  def two_lessons_passed
    if  !current_lesson_complete? &&
        !previous_lesson_complete?
      "danger"
    elsif !current_lesson_complete? ||
          !previous_lesson_complete?
      "warning"
    else
      "stable"
    end
  end

  def one_lesson_passed
    if current_lesson_complete?
      "stable"
    else
      "warning"
    end
  end

  def current_study_status
    if current_lesson && previous_lesson
      two_lessons_passed
    elsif current_lesson
      one_lesson_passed
    else
      "stable"
    end
  end
end