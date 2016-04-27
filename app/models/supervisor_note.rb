# frozen_string_literal: true
# A note added by a Nurse Supervisor to a Nurse's record.
class SupervisorNote < ActiveRecord::Base
  belongs_to :nurse

  validates :nurse, :note, presence: true
end
