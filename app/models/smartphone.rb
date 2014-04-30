# Study phone given to Participant, or Participants own phone
class Smartphone < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "smartphone"
  belongs_to :participant

  validates :number,
            presence: true
end
