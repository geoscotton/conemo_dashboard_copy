# Study Participant
class Participant < ActiveRecord::Base
  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  has_one :first_contact
  has_one :first_appointment
  has_one :second_contact
  has_one :smartphone
  has_many :reminder_messages

  validates :first_name,
            :last_name,
            :study_identifier,
            :family_health_unit_name,
            :family_record_number,
            :phone,
            :key_chronic_disorder,
            :enrollment_date,
            presence: true

  enum status: [:pending, :active, :ineligible]
  enum gender: [:male, :female]
  enum key_chronic_disorder: [:diabetes, :hypertension]

  scope :pending, -> { where(status: 'pending') }
  scope :active, -> { where(status: 'active') }

  def status_enum
    ["pending", "active", "ineligible"]
  end

  def gender_enum
    ["male", "female"]
  end

  def key_chronic_disorder_enum
    ["diabetes", "hypertension"]
  end
end
