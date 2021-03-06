# frozen_string_literal: true
require "bit_core_decorators/slideshow"

# A day's worth of content to be viewed by a Participant.
class Lesson < ActiveRecord::Base
  belongs_to :slideshow,
             class_name: "BitCore::Slideshow",
             foreign_key: :bit_core_slideshow_id
  has_many :slides, through: :slideshow
  has_many :content_access_events, dependent: :restrict_with_exception
  has_many :session_events, dependent: :restrict_with_exception
  has_many :participants, through: :content_access_events

  validates :title,
            :day_in_treatment,
            :locale,
            :guid,
            :slideshow,
            presence: true
  validates :has_activity_planning, inclusion: { in: [true, false] }

  before_validation :generate_guid, :create_slideshow, on: :create
  after_destroy :destroy_slideshow

  def self.available_for(participant)
    where(locale: participant.locale)
      .where("day_in_treatment <= ?", participant.study_day)
  end

  def find_slide(slide_id)
    slideshow.slides.find(slide_id)
  end

  def build_slide(params = {})
    slideshow.slides.build({ position: last_position + 1 }.merge(params))
  end

  def destroy_slide(slide)
    return unless slide.destroy

    slides.order(:position).each_with_index do |s, i|
      s.update(position: i + 1)
    end
  end

  def update_slide_order(ids)
    self.class.transaction do
      self.class.connection.execute(
        "SET CONSTRAINTS bit_core_slide_position DEFERRED"
      )
      ids.each_with_index do |id, index|
        slides.find(id).update_attribute(:position, index + 1)
      end
    end
  end

  private

  def generate_guid
    self.guid = SecureRandom.uuid
  end

  def create_slideshow
    self.slideshow = BitCore::Slideshow.create(title: title)
  end

  def destroy_slideshow
    return if Lesson.exists?(bit_core_slideshow_id: bit_core_slideshow_id)

    slideshow.destroy
  end

  def last_position
    slides.order(:position).select(:position).last.try(:position) || 0
  end
end
