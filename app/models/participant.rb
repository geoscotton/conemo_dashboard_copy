# Study Participant
class Participant < ActiveRecord::Base
  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  has_one :first_contact, dependent: :destroy
  has_one :first_appointment, dependent: :destroy
  has_one :second_contact, dependent: :destroy
  has_one :smartphone, dependent: :destroy
  has_many :reminder_messages, dependent: :destroy
  has_many :app_logins, dependent: :destroy

  STATUS = ["pending", "active", "ineligible"]
  GENDER = ["male", "female"]
  KEY_CHRONIC_DISORDER =  ["diabetes", "hypertension"]

  validates :first_name,
            :last_name,
            :study_identifier,
            :family_health_unit_name,
            :family_record_number,
            :phone,
            :key_chronic_disorder,
            :enrollment_date,
            presence: true

  validates :status, inclusion: { in: STATUS }
  validates :key_chronic_disorder, inclusion: { in: KEY_CHRONIC_DISORDER }
  validates :gender, inclusion: { in: GENDER }

  validate :enrollment_date_is_sane

  scope :ineligible, -> { where(status: "ineligible") }
  scope :pending, -> { where(status: "pending") }
  scope :active, -> { where(status: "active") }

  def notes
    notes = []
    if first_appointment
      notes << first_appointment.notes
    end
    if second_contact
      notes << second_contact.notes
    end
    notes
  end

  def seven_day_access
    app_logins.where("occurred_at > ?", Date.today - 7.days)
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
