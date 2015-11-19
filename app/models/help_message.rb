# receives data via prw staff message table
class HelpMessage < ActiveRecord::Base
  belongs_to :participant

  validates :read, inclusion: { in: [true, false] }
  validates :message, :sent_at, :participant, presence: true
end
