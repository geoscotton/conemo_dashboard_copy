# Tracks each time participant logs in to phone app; backed by prw
class AppLogin < ActiveRecord::Base
  establish_connection :prw
  self.table_name = "app_login"
  alias_attribute :participant_identifier, :FEATURE_VALUE_DT_user_id
  alias_attribute :login, :eventDateTime
  alias_attribute :guid, :GUID

   # def zonedEventDateTime
   #   date_and_time = "%m-%d-%Y %H:%M:%S %Z"
   #   unzoned = eventDateTime.in_time_zone('UTC').strftime("%m-%d-%Y %H:%M:%S")
   #   zone = ConemoDashboard::Application.config.time_zone

   #   DateTime.strptime("#{ unzoned } #{ zone }", date_and_time)
   # end
end