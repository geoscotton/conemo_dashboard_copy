# frozen_string_literal: true
# Represents the third meeting of the Nurse with the Participant.
class ThirdContact < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "third_contact"

  FINAL_CALL_ABSOLUTE_DELAY = 6.weeks
  FINAL_CALL_RELATIVE_DELAY = 3.weeks

  belongs_to :participant
  has_many :patient_contacts

  accepts_nested_attributes_for :patient_contacts

  serialize :difficulties

  validates :participant,
            :contact_at,
            :session_length,
            :difficulties,
            presence: true

  after_initialize :populate_timestamps
  before_validation :sanitize_difficulties

  private

  def default_contact_at
    Tasks::FollowUpCallWeekThree.find_by(participant: participant)
                                .try(:scheduled_at) || Time.zone.now
  end

  def populate_timestamps
    self.contact_at ||= default_contact_at
  end

  def sanitize_difficulties
    return unless difficulties.try(:count) == 1 && difficulties.first.blank?

    self.difficulties = nil
  end
end
