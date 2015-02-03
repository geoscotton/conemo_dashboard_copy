# backed by PRW; imports into content access events
class LessonDatum < ActiveRecord::Base
  establish_connection :prw

  def content_access_event_exists?
    ContentAccessEvent.exists?(lesson_datum_guid: self.GUID)
  end
end
