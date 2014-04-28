# Manage Lesson Slides.
class SlidesController < ApplicationController
  before_action :find_lesson

  def new
    @slide = @lesson.build_slide
    authorize! :new, @slide
  end

  def create
    @slide = @lesson.build_slide(slide_params)
    authorize! :create, @slide

    if @slide.save
      redirect_to lesson_url(@lesson),
                  notice: I18n.t("conemo.controllers.slides.saved")
    else
      flash.now[:alert] = I18n.t("conemo.controllers.slides.not_saved")
      render :new
    end
  end

  private

  def find_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end

  def slide_params
    params.require(:slide).permit(:title, :body)
  end
end
