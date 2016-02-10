require "securerandom"

# An authenticatable person who uses the site, is a Nurse or Researcher
class User < ActiveRecord::Base
  include Status

  ROLES = {
    admin: "admin",
    nurse: "nurse",
    nurse_supervisor: "nurse_supervisor"
  }.freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable

  has_many :participants,
           foreign_key: :nurse_id,
           dependent: :nullify,
           inverse_of: :nurse
  has_many :reminder_messages, foreign_key: :nurse_id, dependent: :destroy

  validates :email, :phone, :first_name, :last_name, :locale, presence: true
  validates :role, inclusion: {in: ROLES.values}
  validates :timezone, inclusion: {in: ActiveSupport::TimeZone::MAPPING.keys}

  before_validation :set_password
  before_save :sanitize_number

  def active_participants
    participants.where(status: "active")
  end

  def last_and_first_name
    "#{last_name}, #{first_name}"
  end

  def admin?
    role == ROLES[:admin]
  end

  def nurse?
    role == ROLES[:nurse]
  end

  private

  def set_password
    return unless password.nil?

    self.password = self.password_confirmation = SecureRandom.uuid
  end

  def sanitize_number
    self.phone = phone.gsub(/[^0-9]/, "")
  end
end
