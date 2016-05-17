# frozen_string_literal: true
# A physical device used by a Participant that has been unassigned and/or
# reassigned.
class PastDeviceAssignment < ActiveRecord::Base
  belongs_to :participant
end
