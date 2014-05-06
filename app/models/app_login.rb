# Tracks each time participant logs in to phone app
class AppLogin < ActiveRecord::Base
  belongs_to :participant
end
