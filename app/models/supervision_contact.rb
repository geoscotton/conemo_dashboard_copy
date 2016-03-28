# frozen_string_literal: true
# An unscheduled call between a Nurse Supervisor and a Nurse.
class SupervisionContact < ActiveRecord::Base
  belongs_to :nurse

  validates :contact_at, :contact_kind, :nurse, presence: true
end
