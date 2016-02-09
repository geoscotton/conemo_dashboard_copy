# Patient app use data imported from PRI.
# Each represents the COMPLETION of a Session (Lesson).
class ContentAccessEvent < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :participant
  has_one :response, dependent: :destroy

  delegate :answer, to: :response, allow_nil: true

  accepts_nested_attributes_for :response

  attr_accessor :lesson_guid

  validates :lesson, :participant, :day_in_treatment_accessed, :accessed_at,
            :uuid, presence: true

  before_validation :set_uuid, :set_lesson

  def late?
    day_in_treatment_accessed > lesson.day_in_treatment
  end

  def response_attributes=(value)
    response = JSON.parse(value)
    super({ answer: response["answer"].to_json })
  rescue TypeError
    super value
  end

  private

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def set_lesson
    self.lesson ||= Lesson.find_by(guid: lesson_guid)
  end
end
