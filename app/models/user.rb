# An authenticatable person who uses the site, is a Nurse or Researcher
class User < ActiveRecord::Base
  include Status
  
  ROLES = { admin: "admin", nurse: "nurse" }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :participants,
           foreign_key: :nurse_id,
           dependent: :nullify,
           inverse_of: :nurse
  has_many :reminder_messages, foreign_key: :nurse_id, dependent: :destroy

  validates :email, :phone, :first_name, :last_name, :locale, presence: true
  validates :role, inclusion: { in: ROLES.values }
  before_save :sanitize_number

  def sanitize_number
    self.phone = self.phone.gsub(/[^0-9]/, "")
  end

  def admin?
    role == ROLES[:admin]
  end

  def nurse?
    role == ROLES[:nurse]
  end
end