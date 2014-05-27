# Study Participant
class Participant < ActiveRecord::Base
  include Status

  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  has_one :first_contact, dependent: :destroy
  has_one :first_appointment, dependent: :destroy
  has_one :second_contact, dependent: :destroy
  has_one :smartphone, dependent: :destroy
  has_many :reminder_messages, dependent: :destroy
  has_many :content_access_events, dependent: :destroy
  has_many :lessons, through: :content_access_events
  has_many :patient_contacts, dependent: :destroy
  has_many :help_messages, dependent: :destroy
  has_many :logins, dependent: :destroy

  STATUS = ["pending", "active", "ineligible"]
  GENDER = ["male", "female"]
  KEY_CHRONIC_DISORDER =  ["diabetes", "hypertension"]

  validates :first_name,
            :last_name,
            :family_health_unit_name,
            :family_record_number,
            :phone,
            :key_chronic_disorder,
            :enrollment_date,
            :locale,
            presence: true

  validates :study_identifier, uniqueness: true, presence: true
  validates :status, inclusion: { in: STATUS }
  validates :key_chronic_disorder, inclusion: { in: KEY_CHRONIC_DISORDER }
  validates :gender, inclusion: { in: GENDER }

  validate :enrollment_date_is_sane

  before_validation :sanitize_number

  scope :ineligible, -> { where(status: "ineligible") }
  scope :pending, -> { where(status: "pending") }
  scope :active, -> { where(status: "active") }

  def seven_day_access
    logins.where("logged_in_at > ?", Date.today - 7.days)
  end

  def study_day
    if start_date
      ((Date.today - start_date).to_i) + 1
    end
  end

  private

  def sanitize_number
    self.phone = self.phone.gsub(/[^0-9]/, "")
  end

  def enrollment_date_is_sane
    unless enrollment_date.nil? || enrollment_date > Date.today - 5.years
      errors.add(
        :enrollment_date,
        I18n.t("conemo.models.participant.enrollment_date_is_sane_error")
      )
    end
  end
end
