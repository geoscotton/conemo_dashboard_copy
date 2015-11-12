# receives data via prw staff message table
class HelpMessage < ActiveRecord::Base
  belongs_to :participant

  validates :read, inclusion: { in: [true, false] }
end
