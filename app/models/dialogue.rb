class Dialogue < ActiveRecord::Base
  has_many :content_access_events
end
