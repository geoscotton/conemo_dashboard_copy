# frozen_string_literal: true
# A record of a call placed by a Nurse to a Participant.
class HelpRequestCall < ActiveRecord::Base
  CANCELLED = "CANCEL"

  belongs_to :participant

  validates :participant, :contact_at, :explanation, presence: true

  def self.cancelled
    where(arel_table[:explanation].matches("#{CANCELLED}%"))
  end

  def human_explanation
    explanation.gsub(/#{CANCELLED} /, "")
  end
end
