# An authenticatable person who uses the site, is a Nurse or Researcher
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :participants, foreign_key: :nurse_id, dependent: :destroy
  has_many :reminder_messages, foreign_key: :nurse_id, dependent: :destroy

  validates :phone, presence: true

  ROLES = ["admin", "nurse"]

  def role_enum
    ["admin", "nurse"]
  end
end
