# frozen_string_literal: true
# Information gathered by phone after First Appointment
class SecondContact < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "second_contact"

  THIRD_CONTACT_ABSOLUTE_DELAY = 3.weeks
  THIRD_CONTACT_RELATIVE_DELAY = 2.weeks

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
    Tasks::FollowUpCallWeekOne.find_by(participant: participant)
                              .try(:scheduled_at) || Time.zone.now
  end

  def populate_timestamps
    self.contact_at ||= default_contact_at
  end

  def sanitize_difficulties
    return unless difficulties.try(:count).to_i >= 1

    self.difficulties = difficulties.delete_if(&:blank?)
    self.difficulties = nil if difficulties.empty?
  end
end
