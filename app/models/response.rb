# Patient response in phone app imported from PRI
class Response < ActiveRecord::Base
  belongs_to :content_access_event

  has_one :participant,
          through: :content_access_event
  
  def parse_responses
    JSON.parse(answer)
  end
end
