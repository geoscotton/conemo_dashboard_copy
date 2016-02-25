# frozen_string_literal: true

# Study Participant
class Participant < ActiveRecord::Base
  include Status

  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  has_one :final_appointment, dependent: :destroy
  has_one :first_appointment, dependent: :destroy
  has_one :first_contact, dependent: :destroy
  has_one :second_contact, dependent: :destroy
  has_one :smartphone, dependent: :destroy
  has_one :third_contact, dependent: :destroy
  has_many :content_access_events, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :help_messages, dependent: :destroy
  has_many :lessons, through: :content_access_events
  has_many :logins, dependent: :destroy
  has_many :participant_start_dates, dependent: :destroy
  has_many :patient_contacts, dependent: :destroy
  has_many :planned_activities, dependent: :destroy
  has_many :reminder_messages, dependent: :destroy
  has_many :session_events, dependent: :destroy

  PENDING ||= "pending".freeze
  ACTIVE ||= "active".freeze
  INELIGIBLE ||= "ineligible".freeze
  STATUS ||= [PENDING, ACTIVE, INELIGIBLE].freeze
  GENDER ||= %w( male female ).freeze

  validates :first_name,
            :last_name,
            :family_health_unit_name,
            :family_record_number,
            :phone,
            :enrollment_date,
            :locale,
            presence: true

  validates :study_identifier, uniqueness: true, presence: true
  validates :status, inclusion: {in: STATUS}
  validates :gender, inclusion: {in: GENDER}

  validate :enrollment_date_is_sane

  before_validation :sanitize_number
  after_save :create_synchronizable_resources
  after_create :create_configuration_token

  scope :ineligible, -> { where(status: INELIGIBLE) }
  scope :pending, -> { where(status: PENDING) }
  scope :active, -> { where(status: ACTIVE) }

  def last_and_first_name
    "#{last_name}, #{first_name}"
  end

  def seven_day_access
    logins.where("logged_in_at > ?", Time.zone.today - 7.days)
  end

  def study_day
    if start_date
      (Time.zone.today - start_date).to_i + 1
    end
  end

  private

  def sanitize_number
    return unless phone.respond_to?(:gsub)

    self.phone = phone.gsub(/[^0-9]/, "")
  end

  def enrollment_date_is_sane
    unless enrollment_date.nil? || enrollment_date > Time.zone.today - 5.years
      errors.add(
          :enrollment_date,
          I18n.t("conemo.models.participant.enrollment_date_is_sane_error")
      )
    end
  end

  def create_synchronizable_resources
    pushable_resources = %w(
      ContentAccessEvent
      Device
      ExceptionReport
      HelpMessage
      Login
      ParticipantStartDate
      PlannedActivity
      SessionEvent
    )

    pushable_resources.each do |resource_name|
      next if TokenAuth::SynchronizableResource.exists?(
        entity_id: id,
        class_name: resource_name
      )

      TokenAuth::SynchronizableResource.create!(
        entity_id: id,
        entity_id_attribute_name: "participant_id",
        name: resource_name.underscore.pluralize,
        class_name: resource_name,
        is_pullable: false,
        is_pushable: true
      )
    end
  end

  def create_configuration_token
    TokenAuth::ConfigurationToken.create entity_id: id
  end
end
