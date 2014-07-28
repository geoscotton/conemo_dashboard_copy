class DialoguesController < ApplicationController
  layout "lesson_editor"

  def index
    authorize! :index, Dialogue
    @dialogues = locale_dialogues.order('day_in_treatment ASC')
  end

  def show
    authorize! :show, find_dialogue
  end

  def new
    @dialogue = Dialogue.new(locale: I18n.locale)
    authorize! :new, @dialogue
  end

  def create
    @dialogue = Dialogue.new({locale: I18n.locale}.merge(dialogue_params))
    authorize! :create, @dialogue

    if @dialogue.save
      redirect_to dialogues_url               
    else
      flash.now[:alert] = I18n.t("conemo.controllers.dialogues.not_saved") +
          ": " + validation_errors
      render :new
    end
  end

  def edit
    authorize! :edit, find_dialogue
  end

  def update
    authorize! :update, find_dialogue

    if @dialogue.update(dialogue_params)
      redirect_to dialogues_url
    else
      flash.now[:alert] = I18n.t("conemo.controllers.dialogues.not_saved") +
          ": " + validation_errors
      render :new
    end
  end

  def destroy
    authorize! :destroy, find_dialogue

    if @dialogue.destroy
      redirect_to dialogues_url
    else
      redirect_to dialogues_url,
                  alert: I18n.t("conemo.controllers.dialogues.not_destroyed") +
                      ": " + validation_errors
    end
  end

  private

  def locale_dialogues
    Dialogue.where(locale: I18n.locale)
  end

  def find_dialogue
    @dialogue = locale_dialogues.find(params[:id])
  end

  def dialogue_params
    params.require(:dialogue).permit(:title, :day_in_treatment, :message, :yes_text, :no_text)
  end

  def validation_errors
    @dialogue.errors.full_messages.join(", ")
  end

end
