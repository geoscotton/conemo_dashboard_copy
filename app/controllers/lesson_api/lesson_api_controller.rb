module LessonApi
  class LessonApiController < ApplicationController
    skip_before_action :authenticate_user!

    def lessons
      @lessons = locale_lessons('pt-BR').order('day_in_treatment ASC') +
          locale_lessons('es-PE').order('day_in_treatment ASC') +
          locale_lessons('en').order('day_in_treatment ASC')

      render "lessons/index"
    end

    private

    def locale_lessons(locale)
      Lesson.where(locale: locale)
    end
  end
end