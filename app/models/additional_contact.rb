# frozen_string_literal: true
# Represents an extra contact point between a Nurse and Participant.
class AdditionalContact < ActiveRecord::Base
  belongs_to :participant
  belongs_to :nurse

  validates :participant, :nurse, :scheduled_at, :kind, presence: true
end
