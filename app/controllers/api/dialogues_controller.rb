module Api
  # JSON CRUD Dialogues.
  class DialoguesController < ApplicationController
    skip_before_action :authenticate_user!

    def index
      @dialogues = locale_dialogues("pt-BR").order("day_in_treatment ASC") +
          locale_dialogues("es-PE").order("day_in_treatment ASC") +
          locale_dialogues("en").order("day_in_treatment ASC")

      render "dialogues/index.json"
    end

    private

    def locale_dialogues(locale)
      Dialogue.where(locale: locale)
    end
  end
end
