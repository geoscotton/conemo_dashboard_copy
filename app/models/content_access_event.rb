# Patient app use data imported from PRI
class ContentAccessEvent < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :participant
  has_one :response
  delegate :answer, to: :response

  def late?
    day_in_treatment_accessed > lesson.day_in_treatment
  end
end