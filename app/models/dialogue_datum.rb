# backed by PRW; imports into content access events
class DialogueDatum < ActiveRecord::Base
  establish_connection :prw

  def content_access_event_exists?
    ContentAccessEvent.exists?(dialogue_datum_guid: self.FEATURE_VALUE_DT_dialogue_guid)
  end
end