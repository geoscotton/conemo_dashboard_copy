# Manages Lessons.
class LessonsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :index, Lesson
    @lessons = Lesson.all
  end

  def show
    @lesson = Lesson.find(params[:id])
    authorize! :show, @lesson
  end

  def new
    @lesson = Lesson.new
    authorize! :new, @lesson
  end

  def create
    @lesson = Lesson.new({ locale: params[:locale] }.merge(lesson_params))
    authorize! :create, @lesson

    if @lesson.save
      redirect_to lessons_url,
                  notice: I18n.t("conemo.controllers.lessons.saved")
    else
      flash.now[:error] = I18n.t("conemo.controllers.lessons.not_saved")
      render :new
    end
  end

  def edit
    @lesson = Lesson.find(params[:id])
    authorize! :edit, @lesson
  end

  def update
    @lesson = Lesson.find(params[:id])
    authorize! :update, @lesson
  end

  def destroy
    @lesson = Lesson.find(params[:id])
    authorize! :destroy, @lesson
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :day_in_treatment)
  end
end
