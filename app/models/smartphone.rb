# frozen_string_literal: true
# Study phone given to Participant, or Participants own phone
class Smartphone < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "smartphone"
  belongs_to :participant

  validates :participant, :number, :phone_identifier, presence: true

  before_validation :sanitize_number

  private

  def sanitize_number
    return if number.nil?

    self.number = number.gsub(/[^0-9]/, "")
  end
end
