# Study Participant
class Participant < ActiveRecord::Base
  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  has_one :first_contact, dependent: :destroy
  has_one :first_appointment, dependent: :destroy
  has_one :second_contact, dependent: :destroy
  has_one :smartphone, dependent: :destroy
  has_many :reminder_messages, dependent: :destroy

  validates :first_name,
            :last_name,
            :study_identifier,
            :family_health_unit_name,
            :family_record_number,
            :phone,
            :key_chronic_disorder,
            :enrollment_date,
            presence: true
  validate :enrollment_date_is_sane

  enum status: [:pending, :active, :ineligible]
  enum gender: [:male, :female]
  enum key_chronic_disorder: [:diabetes, :hypertension]

  scope :pending, -> { where(status: "pending") }
  scope :active, -> { where(status: "active") }

  def status_enum
    ["pending", "active", "ineligible"]
  end

  def gender_enum
    ["male", "female"]
  end

  def key_chronic_disorder_enum
    ["diabetes", "hypertension"]
  end

  private

  def enrollment_date_is_sane
    unless enrollment_date.nil? || enrollment_date > Date.today - 5.years
      errors.add(
        :enrollment_date,
        I18n.t("conemo.models.participant.enrollment_date_is_sane_error")
      )
    end
  end
end
