# A day's worth of content to be viewed by a Participant.
class Lesson < ActiveRecord::Base
  belongs_to :slideshow,
             class_name: "BitCore::Slideshow",
             foreign_key: :bit_core_slideshow

  validates :title, :day_in_treatment, :locale, presence: true
end
