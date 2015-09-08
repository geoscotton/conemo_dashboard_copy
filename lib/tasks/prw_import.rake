namespace :prw_import do
  desc "gets conemo prw data"
  task sync: :environment do

    puts "******** Begin prw_import at #{Time.now} **********"
    
    begin
      ImportPrwData.set_start_dates
    rescue StandardError => e
      next unless defined?(Raven)
      Raven.extra_context message: "Start Date Rake Failed"
      Raven.capture_exception e
      Raven::Context.clear!
    end

    begin
      ImportPrwData.import_logins
    rescue StandardError => e
      next unless defined?(Raven)
      Raven.extra_context message: "Login Rake Failed"
      Raven.capture_exception e
      Raven::Context.clear!
    end

    begin
      ImportPrwData.import_session_access_events
    rescue StandardError => e
      next unless defined?(Raven)
      Raven.extra_context message: "Content Access Rake Failed"
      Raven.capture_exception e
      Raven::Context.clear!
    end

    begin
      ImportPrwData.import_content_completion_events
    rescue StandardError => e
      next unless defined?(Raven)
      Raven.extra_context message: "Content Access Rake Failed"
      Raven.capture_exception e
      Raven::Context.clear!
    end

    begin
      ImportPrwData.import_help_messages
    rescue StandardError => e
      next unless defined?(Raven)
      Raven.extra_context message: "Help Message Rake Failed"
      Raven.capture_exception e
      Raven::Context.clear!
    end
  end
end

class ImportPrwData

  def self.set_start_dates
    puts "begin start_date import at #{Time.now}"
    participants = Participant.active

    participants.each do |participant|
      begin
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
      rescue StandardError => error
        Raven.extra_context message: "Participant: #{participant.id} | StartDate import error: #{error}"
        Raven.capture_exception error
        Raven::Context.clear!
      end
    end
  end

  def self.import_logins
    puts "begin logins import at #{Time.now}"
    if AppLogin.all.any?
      participants = Participant.active
      participants.each do |participant|
        begin
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
        rescue StandardError => error
          Raven.extra_context message: "Participant: #{participant.id} | Login import error: #{error}"
          Raven.capture_exception error
          Raven::Context.clear!
        end
      end
    end
  end

  def self.import_session_access_events
    puts "begin lesson access import at #{Time.now}"
    ClientSessionEvent.access_events.each do |event|
      participant = Participant
                    .where(study_identifier: event.participant_identifier)
                    .first
      lesson = Lesson.where(guid: event.lesson_guid).first

      next unless participant && lesson

      attributes = {
        participant_id: participant.id,
        lesson_id: lesson.id,
        event_type: ClientSessionEvent::TYPES.access
      }

      next if SessionEvent.exists?(attributes)

      begin
        SessionEvent.create!(attributes.merge(occurred_at: event.occurred_at))
      rescue StandardError => error
        Raven.extra_context message: "Participant: #{participant.id} | Lesson access import error: #{error}"
        Raven.capture_exception error
        Raven::Context.clear!
      end
    end
  end

  def self.import_content_completion_events
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
            Raven.extra_context message: "Participant: #{participant.id} | Lesson completion import error: #{error}"
            Raven.capture_exception error
            Raven::Context.clear!
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
          begin
            ActiveRecord::Base.transaction do 
          
              content_access_event = ContentAccessEvent.new(participant: participant,
                                                            accessed_at: datum.eventDateTime,
                                                            dialogue: dialogue,
                                                            day_in_treatment_accessed: datum.FEATURE_VALUE_DT_days_in_treatment,
                                                            dialogue_datum_guid: datum.GUID
                                                            )
              if content_access_event.save!
                puts "dialogue content_access_event created for #{participant.study_identifier}"
                response = content_access_event.build_response(question: dialogue.title, answer: datum.FEATURE_VALUE_DT_answer)
                response.save!
              end
            end
          rescue StandardError => error
            Raven.extra_context message: "Participant: #{participant.id} | Dialogue access import error: #{error}"
            Raven.capture_exception error
            Raven::Context.clear!
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
          begin
            help_message = HelpMessage.new(participant: participant,
                                          read: false,
                                          message: message.FEATURE_VALUE_DT_message,
                                          staff_message_guid: message.GUID,
                                          sent_at: Time.at(message.timestamp)
                                          )
            if help_message.save!
              puts "help_message created for #{participant.study_identifier}"
            end
          rescue StandardError => error
            Raven.extra_context message: "Participant: #{participant.id} | Help message import error: #{error}"
            Raven.capture_exception error
            Raven::Context.clear!
          end
        end
      end
    end
  end
end
