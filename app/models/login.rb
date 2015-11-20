# Represents the Participant opening the mobile app.
class Login < ActiveRecord::Base
  belongs_to :participant
end
