# A day's worth of content to be viewed by a Participant.
class Lesson < ActiveRecord::Base
  belongs_to :slideshow,
             class_name: "BitCore::Slideshow",
             foreign_key: :bit_core_slideshow_id
  has_many :slides, through: :slideshow

  validates :title,
            :day_in_treatment,
            :locale,
            :guid,
            :slideshow,
            presence: true

  before_validation :generate_guid, :create_slideshow, on: :create
  after_destroy :destroy_slideshow

  def find_slide(slide_id)
    slideshow.slides.find(slide_id)
  end

  def build_slide(params = {})
    slideshow.slides.build({ position: last_position + 1 }.merge(params))
  end

  def destroy_slide(slide)
    if slide.destroy
      slides.order(:position).each_with_index do |s, i|
        s.update(position: i + 1)
      end
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
    slideshow.destroy
  end

  def last_position
    slides.order(:position).select(:position).last.try(:position) || 0
  end
end
