class Participant < ActiveRecord::Base
  belongs_to :nurse, class_name: 'User', foreign_key: :nurse_id
  validates :first_name, 
            :last_name, 
            :study_identifier, 
            :family_health_unit_name,
            :family_record_number,
            :phone,
            :key_chronic_disorder,
            :enrollment_date,
            presence: true

  enum status: [:pending, :active, :ineligible]
  
  def status_enum
    ["pending", "active", "ineligible"]
  end
  
  enum gender: [:male, :female]

  def gender_enum
    ["male", "female"]
  end

  enum key_chronic_disorder: [:diabetes, :hypertension]

  def key_chronic_disorder_enum
    ["diabetes", "hypertension"]
  end
end
