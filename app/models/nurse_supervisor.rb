# frozen_string_literal: true
# Manages Participant and Nurse assignments.
class NurseSupervisor < User
  has_many :nurses
end
