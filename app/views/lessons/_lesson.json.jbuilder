json._class "Lesson"
json.title lesson.title
json.dayInTreatment lesson.day_in_treatment
json.l10n lesson.locale
json.guid lesson.guid

json.slides lesson.slides, partial: "slides/slide", as: :slide
