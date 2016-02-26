# frozen_string_literal: true
module Api
  # JSON CRUD Lessons.
  class LessonsController < ApplicationController
    skip_before_action :authenticate_user!

    def index
      @lessons = locale_lessons("pt-BR").order("day_in_treatment ASC") +
                 locale_lessons("es-PE").order("day_in_treatment ASC") +
                 locale_lessons("en").order("day_in_treatment ASC")

      render "lessons/index.json"
    end

    private

    def locale_lessons(locale)
      Lesson.where(locale: locale)
    end
  end
end
