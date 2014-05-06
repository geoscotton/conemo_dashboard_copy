# Patient response in phone app imported from PRI
class Response < ActiveRecord::Base
  belongs_to :content_access_event
end
