namespace :prw_import do
  desc "gets conemo prw data"
  task sync: :environment do

    LessonDatum.all.each do |datum|
      if !datum.content_access_event_exists?

        participant = Participant.where(study_identifier: datum.FEATURE_VALUE_DT_user_id).first
        lesson = Lesson.where(guid: datum.FEATURE_VALUE_DT_lesson_guid).first

        if participant && lesson
          
          content_access_event = ContentAccessEvent.new(participant: participant,
                                                        accessed_at: datum.eventDateTime,
                                                        lesson: lesson,
                                                        day_in_treatment_accessed: datum.FEATURE_VALUE_DT_days_in_treatment,
                                                        lesson_datum_guid: datum.GUID
                                                        )
          if content_access_event.save
            puts "content_access_event created for #{participant.study_identifier}"
            datum.parse_responses.each do |key, value|
              response = content_access_event.build_response(name: key, answer: value)
              response.save
              puts response.name
              puts response.key
            end
          end
        end
      end
    end
  end
end