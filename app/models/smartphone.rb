# Study phone given to Participant, or Participants own phone
class Smartphone < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "smartphone"
  belongs_to :participant

  validates :number,
            presence: true

  before_save :sanitize_number

  def sanitize_number
    self.number = self.number.gsub(/[^0-9]/, "")
  end
end