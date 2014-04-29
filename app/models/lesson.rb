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
    slideshow.slides.build(params)
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
end
