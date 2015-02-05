namespace :prw_import do
  desc "gets conemo prw data"
  task sync: :environment do

    puts "******** Begin prw_import at #{Time.now} **********"
    ImportPrwData.set_start_dates
    ImportPrwData.import_logins
    ImportPrwData.import_content_access_events
    ImportPrwData.import_help_messages

  end
end

class ImportPrwData

  def self.set_start_dates
    puts "begin start_date import at #{Time.now}"
    participants = Participant.active

    participants.each do |participant|
      StartDate.all.each do |date|
        if date.participant_identifier == participant.study_identifier
          if !participant.start_date
            participant.start_date = date.start_date.to_date
            participant.save
            puts "start date created for #{participant.study_identifier}" 
          elsif participant.start_date < date.start_date.to_date
            participant.start_date = date.start_date.to_date
            participant.save
            puts "start date updated for #{participant.study_identifier}"
          else
            nil 
          end
        end
      end
    end
  end

  def self.import_logins
    puts "begin logins import at #{Time.now}"
    if AppLogin.all.any?
      participants = Participant.active
      participants.each do |participant|

        AppLogin.all.each do |app_login|
          if participant.study_identifier == app_login.participant_identifier
            if !Login.exists?(app_login_guid: app_login.guid)
              
              login = participant.logins.new(logged_in_at: app_login.login, app_login_guid: app_login.guid)
              
              if login.save
                puts "login at #{login.logged_in_at} created for #{participant.study_identifier}"
              end 
            end
          end
        end
        
      end
    end
  end

  def self.import_content_access_events
    puts "begin lesson data import at #{Time.now}"
    
    LessonDatum.all.each do |datum|
      if !datum.content_access_event_exists?

        participant = Participant.where(study_identifier: datum.FEATURE_VALUE_DT_user_id).first
        lesson = Lesson.where(guid: datum.FEATURE_VALUE_DT_lesson_guid).first

        if participant && lesson
          begin
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
            end 
          rescue StandardError => error
            puts error
          end
        end
      end
    end
    
    puts "begin dialogue data import at #{Time.now}"
    DialogueDatum.all.each do |datum|
      if !datum.content_access_event_exists?

        participant = Participant.where(study_identifier: datum.FEATURE_VALUE_DT_user_id).first
        dialogue = Dialogue.where(guid: datum.FEATURE_VALUE_DT_dialogue_guid).first

        if participant && dialogue
          
          content_access_event = ContentAccessEvent.new(participant: participant,
                                                        accessed_at: datum.eventDateTime,
                                                        dialogue: dialogue,
                                                        day_in_treatment_accessed: datum.FEATURE_VALUE_DT_days_in_treatment,
                                                        dialogue_datum_guid: datum.GUID
                                                        )
          if content_access_event.save
            puts "dialogue content_access_event created for #{participant.study_identifier}"
            response = content_access_event.build_response(question: dialogue.title, answer: datum.FEATURE_VALUE_DT_answer)
            response.save
          end
        end
      end
    end
  end

  def self.import_help_messages
    puts "begin help messages import at #{Time.now}"
    StaffMessage.all.each do |message|
      if !message.help_message_exists?
        participant = Participant.where(study_identifier: message.FEATURE_VALUE_DT_user_id)
                        .first
        if participant

          help_message = HelpMessage.new(participant: participant,
                                         read: false,
                                         message: message.FEATURE_VALUE_DT_message,
                                         staff_message_guid: message.GUID,
                                         sent_at: Time.at(message.timestamp)
                                        )
          if help_message.save
            puts "help_message created for #{participant.study_identifier}"
          end
        end
      end
    end
  end
end
