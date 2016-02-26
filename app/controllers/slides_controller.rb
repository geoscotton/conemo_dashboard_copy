# frozen_string_literal: true
# Manage Lesson Slides.
class SlidesController < ApplicationController
  before_action :find_lesson

  def show
    authorize! :show, find_slide
  end

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
      flash.now[:alert] = I18n.t("conemo.controllers.slides.not_saved") +
                          ": " + @slide.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    authorize! :edit, find_slide
  end

  def update
    authorize! :update, find_slide

    if @slide.update(slide_params)
      redirect_to lesson_url(@lesson),
                  notice: I18n.t("conemo.controllers.slides.saved")
    else
      flash.now[:alert] = I18n.t("conemo.controllers.slides.not_saved") +
                          ": " + @slide.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    authorize! :destroy, find_slide

    if @lesson.destroy_slide(@slide)
      redirect_to lesson_url(@lesson),
                  notice: I18n.t("conemo.controllers.slides.destroyed")
    else
      redirect_to lesson_url(@lesson),
                  alert: I18n.t("conemo.controllers.slides.not_destroyed") +
                         ": " + @slide.errors.full_messages.join(", ")
    end
  end

  private

  def find_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end

  def find_slide
    @slide = @lesson.find_slide(params[:id])
  end

  def slide_params
    params.require(:slide).permit(:title, :body)
  end
end
