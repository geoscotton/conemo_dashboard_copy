# frozen_string_literal: true
# A note added by a Nurse Supervisor to a Participant's record.
class SupervisorNote < ActiveRecord::Base
  belongs_to :participant

  validates :participant, :note, presence: true
end
