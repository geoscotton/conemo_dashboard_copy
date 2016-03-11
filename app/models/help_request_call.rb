# frozen_string_literal: true
# A record of a call placed by a Nurse to a Participant.
class HelpRequestCall < ActiveRecord::Base
  belongs_to :participant

  validates :participant, :contact_at, :explanation, presence: true
end
