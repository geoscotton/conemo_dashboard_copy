# backed by prw; imports into help messages
class StaffMessage < ActiveRecord::Base
  establish_connection :prw

  def help_message_exists?
    HelpMessage.exists?(staff_message_guid: self.GUID)
  end
end