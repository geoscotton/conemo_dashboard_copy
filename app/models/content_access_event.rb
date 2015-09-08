# Patient app use data imported from PRI.
# Each represents the COMPLETION of a Session (Lesson).
class ContentAccessEvent < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :participant
  belongs_to :dialogue
  has_one :response, dependent: :destroy
  delegate :answer, to: :response, allow_nil: true
  accepts_nested_attributes_for :response

  def late?
    day_in_treatment_accessed > lesson.day_in_treatment
  end
end
