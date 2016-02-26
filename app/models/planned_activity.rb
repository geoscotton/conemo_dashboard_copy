# frozen_string_literal: true
# An activity planned by a Participant in the app.
class PlannedActivity < ActiveRecord::Base
  belongs_to :participant

  validates :uuid, :participant, :name, presence: true
end
