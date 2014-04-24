# An authenticatable person who uses the site.
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :participants, foreign_key: :nurse_id

  validates :phone, presence: true

  ROLES = %w[admin nurse]
end
