# Form data captured during app use.
class LessonDatum < ActiveRecord::Base
  establish_connection :prw

  def content_access_event_exists?
    ContentAccessEvent.exists?(lesson_datum_guid: self.GUID)
  end

  def parse_responses
    JSON.parse(self.FEATURE_VALUE_DT_form_payload)
  end
end
