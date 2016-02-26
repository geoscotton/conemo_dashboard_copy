# frozen_string_literal: true
require "spec_helper"

RSpec.describe Lesson, type: :model do
  fixtures :all

  let(:slideshow) { bit_core_slideshows(:day1) }

  describe "fixtures" do
    it "can be created successfully" do
      expect(Lesson.count).to be > 0
      Lesson.all.each { |l| expect(l).to be_valid }
    end
  end

  describe "callbacks" do
    describe "on create" do
      it "assigns a guid identifier" do
        expect(Lesson.create.guid).not_to be_blank
      end

      it "assigns a new slideshow" do
        expect do
          lesson = Lesson.create(title: "delicious")

          expect(lesson.slideshow).not_to be_nil
          expect(lesson.slideshow.title).to eq "delicious"
        end.to change { BitCore::Slideshow.count }.by(1)
      end
    end

    describe "after destroy" do
      it "destroys the associated slideshow" do
        lesson = Lesson.create(title: "delicious")

        expect do
          lesson.destroy
        end.to change { BitCore::Slideshow.count }.by(-1)
      end
    end
  end

  describe "#find_slide" do
    it "returns the slideshow slide with the associated id" do
      lesson = Lesson.new(slideshow: slideshow)
      slide = slideshow.slides.first

      expect(lesson.find_slide(slide.id)).to eq slide
    end
  end

  describe "#build_slide" do
    it "returns a new slide with its position at the end" do
      last_position = slideshow.slides.order(:position).last.position
      lesson = Lesson.new(slideshow: slideshow)

      slide = lesson.build_slide(body: "bar")

      expect(slide.position).to eq last_position + 1
    end
  end

  describe "#destroy_slide" do
    let(:lesson) { Lesson.new(slideshow: slideshow) }

    it "destroys the slide" do
      expect do
        lesson.destroy_slide(lesson.slides.first)
      end.to change { BitCore::Slide.count }.by(-1)
    end

    it "reorders the existing slides" do
      slide1 = lesson.slides.order(:position).first

      expect do
        lesson.destroy_slide(slide1)
      end.to change { lesson.slides.order(:position).last.position }.by(-1)
    end
  end

  describe "#update_slide_order" do
    let(:lesson) { Lesson.new(slideshow: slideshow) }

    it "updates slides with the provided id order" do
      slide1, slide2 = slideshow.slides.order(:position).to_a

      lesson.update_slide_order([slide2.id, slide1.id])

      new_slide1, new_slide2 = slideshow.slides.order(:position).to_a
      expect(new_slide1.id).to eq slide2.id
      expect(new_slide2.id).to eq slide1.id
    end
  end
end
