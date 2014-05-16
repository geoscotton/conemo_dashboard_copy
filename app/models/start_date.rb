# sets start dates for participants; backed by prw
class StartDate < ActiveRecord::Base
  self.table_name = "start_date"
  establish_connection :prw
  alias_attribute :participant_identifier, :FEATURE_VALUE_DT_user_id
  alias_attribute :start_date, :FEATURE_VALUE_DT_start_date
end