# frozen_string_literal: true
require "securerandom"

# An authenticatable person who uses the site, is a Nurse or Researcher
class User < ActiveRecord::Base
  include Status

  ROLES = {
    admin: "admin",
    nurse: "nurse",
    nurse_supervisor: "nurse_supervisor"
  }.freeze
  SESSION_TIMEOUT = 30.minutes.freeze

  devise :database_authenticatable, :recoverable, :trackable, :validatable,
         :timeoutable, timeout_in: SESSION_TIMEOUT

  validates :email, :phone, :first_name, :last_name, :locale, presence: true
  validates :role, inclusion: { in: ROLES.values }
  validates :timezone, inclusion: { in: ActiveSupport::TimeZone::MAPPING.keys }

  before_validation :set_password
  before_save :sanitize_number

  def last_and_first_name
    "#{last_name}, #{first_name}"
  end

  def admin?
    role == ROLES[:admin]
  end

  def nurse_supervisor?
    role == ROLES[:nurse_supervisor]
  end

  def nurse?
    role == ROLES[:nurse]
  end

  private

  def set_password
    return if password.present? || encrypted_password.present?

    self.password = self.password_confirmation = SecureRandom.uuid
  end

  def sanitize_number
    self.phone = phone.gsub(/[^0-9]/, "")
  end
end
