# An activity planned by a Participant in the app.
class PlannedActivity < ActiveRecord::Base
  validates :uuid, :participant, :name, presence: true
end
