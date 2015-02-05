namespace :responses do
  desc "reloads response data from prw"
  task clean: :environment do
    ContentAccessEvent.where("lesson_id IS NOT NULL").destroy_all
    
    LessonDatum.all.each do |datum|
      if !datum.content_access_event_exists?

        participant = Participant.where(study_identifier: datum.FEATURE_VALUE_DT_user_id).first
        lesson = Lesson.where(guid: datum.FEATURE_VALUE_DT_lesson_guid).first

        if participant && lesson
          ActiveRecord::Base.transaction do 
            content_access_event = ContentAccessEvent.new(participant: participant,
                                                        accessed_at: datum.eventDateTime,
                                                        lesson: lesson,
                                                        day_in_treatment_accessed: datum.FEATURE_VALUE_DT_days_in_treatment,
                                                        lesson_datum_guid: datum.GUID
                                                        )
            content_access_event.save!
            answer = datum.FEATURE_VALUE_DT_form_payload
            response = content_access_event.build_response(answer: answer)
            response.save!
            
            rescue StandardError => error
              puts error
          end
        end
      end
    end
  end
end
