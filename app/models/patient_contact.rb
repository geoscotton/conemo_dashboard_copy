# Class for general patient notes
class PatientContact < ActiveRecord::Base
  belongs_to :participant
end
