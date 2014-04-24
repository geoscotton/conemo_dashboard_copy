class SecondContact < ActiveRecord::Base
  belongs_to :participant, dependent: :destroy

  validates :participant_id,
            :contact_at,
            :session_length,
            presence: true
end
