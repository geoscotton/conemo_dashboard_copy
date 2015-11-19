# Manages Lessons.
class LessonsController < ApplicationController
  layout "lesson_editor"

  def index
    authorize! :index, Lesson
    @lessons = locale_lessons.order("day_in_treatment ASC")
  end

  def show
    authorize! :show, find_lesson
  end

  def new
    @lesson = Lesson.new(locale: I18n.locale)
    authorize! :new, @lesson
  end

  def create
    @lesson = Lesson.new({locale: I18n.locale}.merge(lesson_params))
    authorize! :create, @lesson

    if @lesson.save
      redirect_to lessons_url,
                  notice: I18n.t("conemo.controllers.lessons.saved")
    else
      flash.now[:alert] = I18n.t("conemo.controllers.lessons.not_saved") +
          ": " + validation_errors
      render :new
    end
  end

  def edit
    authorize! :edit, find_lesson
  end

  def update
    authorize! :update, find_lesson

    if @lesson.update(lesson_params)
      redirect_to lessons_url,
                  notice: I18n.t("conemo.controllers.lessons.saved")
    else
      flash.now[:alert] = I18n.t("conemo.controllers.lessons.not_saved") +
          ": " + validation_errors
      render :edit
    end
  end

  def destroy
    authorize! :destroy, find_lesson

    if @lesson.destroy
      redirect_to lessons_url,
                  notice: I18n.t("conemo.controllers.lessons.destroyed")
    else
      redirect_to lessons_url,
                  alert: I18n.t("conemo.controllers.lessons.not_destroyed") +
                      ": " + validation_errors
    end
  end

  def slide_order
    authorize! :update, find_lesson

    @lesson.update_slide_order(slide_order_params)
    flash.now[:notice] = I18n.t("conemo.controllers.lessons.saved")
    render :slide_order_success
  rescue ActiveRecord::ActiveRecordError
    render :slide_order_failure
  end

  private

  def locale_lessons
    Lesson.where(locale: I18n.locale)
  end

  def find_lesson
    @lesson = locale_lessons.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :day_in_treatment)
  end

  def validation_errors
    @lesson.errors.full_messages.join(", ")
  end

  def slide_order_params
    params.require(:slide)
  end
end
