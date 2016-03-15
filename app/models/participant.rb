# frozen_string_literal: true

# Study Participant
class Participant < ActiveRecord::Base
  include Status

  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  has_one :call_to_schedule_final_appointment, dependent: :destroy
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
  has_one :participant_start_date, dependent: :destroy
  has_many :patient_contacts, dependent: :destroy
  has_many :planned_activities, dependent: :destroy
  has_many :session_events, dependent: :destroy

  PENDING ||= "pending"
  ACTIVE ||= "active"
  INELIGIBLE ||= "ineligible"
  COMPLETED ||= "completed"
  STATUS ||= [PENDING, ACTIVE, INELIGIBLE, COMPLETED].freeze
  GENDER ||= %w( male female ).freeze

  validates :first_name,
            :last_name,
            :study_identifier,
            :family_health_unit_name,
            :address,
            :enrollment_date,
            :locale,
            presence: true

  validates :study_identifier, uniqueness: true
  validates :status, inclusion: { in: STATUS }
  validates :gender, inclusion: { in: GENDER }
  validates :contact_person_1_name,
            presence: true,
            if: proc { |participant|
                  participant.alternate_phone_1.present?
                }
  validates :contact_person_2_name,
            presence: true,
            if: proc { |participant|
                  participant.alternate_phone_2.present?
                }
  validates :study_identifier, :phone, :cell_phone, :alternate_phone_1,
            :alternate_phone_2, :emergency_contact_phone,
            :emergency_contact_cell_phone,
            format: /\A[0-9]+\z/, allow_nil: true

  validate :enrollment_date_is_sane

  before_validation :sanitize_number
  after_save :create_synchronizable_resources
  after_create :create_configuration_token

  scope :ineligible, -> { where(status: INELIGIBLE) }
  scope :pending, -> { where(status: PENDING) }
  scope :active, -> { where(status: ACTIVE) }

  def start_date
    participant_start_date.try(:date)
  end

  def last_and_first_name
    "#{last_name}, #{first_name}"
  end

  def study_day
    if start_date
      (Time.zone.today - start_date).to_i + 1
    end
  end

  def complete
    update status: COMPLETED
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
