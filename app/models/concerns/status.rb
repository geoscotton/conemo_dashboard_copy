# Handles Participant overall and individual lesson status logic
module Status
  extend ActiveSupport::Concern

  def prefix
    if locale
      if locale == "en"
        "+"
      elsif locale == "pt-BR"
        "+55"
      elsif locale == "es-PE"
        "+51"
      else
        "+"
      end
    end
  end

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
    access = access_response(lesson)

    if lesson.guid == current_lesson.guid
      "info"
    elsif !access && lesson_released?(next_lesson(lesson))
      "danger"
    elsif access && access.late?
      "warning"
    else
      "success"
    end
  end

  def access_response(lesson)
    content_access_events.where(lesson_id: lesson.id).first
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
    if two_lessons_ago
      two_lessons_ago.content_access_events.where(participant_id: id).any?
    end
  end

  def one_lesson_ago_complete?
    if one_lesson_ago
      one_lesson_ago.content_access_events.where(participant_id: id).any?
    end
  end

  def two_lessons_passed
    if  !one_lesson_ago_complete? &&
        !two_lessons_ago_complete?
      "danger"
    elsif !one_lesson_ago_complete? ||
        !two_lessons_ago_complete?
      "warning"
    else
      "stable"
    end
  end

  def one_lesson_passed
    if one_lesson_ago_complete?
      "stable"
    else
      "warning"
    end
  end

  def current_study_status
    if start_date
      if one_lesson_ago && two_lessons_ago
        two_lessons_passed
      elsif one_lesson_ago
        one_lesson_passed
      elsif content_access_events.any?
        "stable"
      else
        "disabled"
      end
    else
      "none"
    end
  end
end
