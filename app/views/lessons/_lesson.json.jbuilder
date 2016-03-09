# frozen_string_literal: true
json._class "Lesson"
json.title lesson.title
json.dayInTreatment lesson.day_in_treatment
json.l10n lesson.locale
json.guid lesson.guid
json.hasActivityPlanning lesson.has_activity_planning
json.prePlanningContent lesson.pre_planning_content
json.postPlanningContent lesson.post_planning_content
json.nonPlanningContent lesson.non_planning_content
json.feedbackAfterDays lesson.feedback_after_days
json.planningResponseYesContent lesson.planning_response_yes_content
json.planningResponseNoContent lesson.planning_response_no_content
json.nonPlanningResponseContent lesson.non_planning_response_content

json.slides lesson.slides, partial: "slides/slide", as: :slide
