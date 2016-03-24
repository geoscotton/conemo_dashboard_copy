# frozen_string_literal: true
# A meeting between a Nurse Supervisor and a Nurse.
class SupervisionSession < ActiveRecord::Base
  belongs_to :nurse

  validates :session_at, :session_length, :meeting_kind, :contact_kind, :nurse,
            presence: true

  serialize :topics
end
