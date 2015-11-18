# Tracks each time participant logs in to phone app; backed by prw
class AppLogin < ActiveRecord::Base
  establish_connection :prw
  self.table_name = "app_login"
  alias_attribute :participant_identifier, :FEATURE_VALUE_DT_user_id
  alias_attribute :login, :eventDateTime
  alias_attribute :guid, :GUID
end
