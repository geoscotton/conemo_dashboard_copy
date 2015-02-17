require 'rubygems'
require 'twilio-ruby'

namespace :sms do
  desc "sends pending messages that are due"
  task message: :environment do

    puts "******** Begin SMS Rake #{Time.now} *********"
    @account_sid = ConemoDashboard::Application.config.twilio_account_sid 
    @auth_token = ConemoDashboard::Application.config.twilio_auth_token 
    @client = Twilio::REST::Client.new(@account_sid, @auth_token)

    @account = @client.account

    reminder_messages = ReminderMessage.where(status: "pending")

    reminder_messages.each do |reminder_message|
      Time.use_zone(reminder_message.participant.nurse.timezone) do

        begin
          if reminder_message.notification_time && reminder_message.notification_time <= Time.current
            if reminder_message.message_type == "participant"
              country_code = reminder_message.participant.prefix
              if reminder_message.participant.smartphone
                phone_number = reminder_message.participant.smartphone.number
              else
                phone_number = reminder_message.participant.phone
              end
              sent_to = reminder_message.participant.study_identifier
            else
              country_code = reminder_message.nurse.prefix
              phone_number = reminder_message.nurse.phone
              sent_to = "#{reminder_message.nurse.last_name}, #{reminder_message.nurse.first_name}"
            end

            begin
              if reminder_message.split_message #special case for pt-BR locale
                @message = @account.sms.messages.create({ from: "+13125488213", to: "#{country_code}#{phone_number}", body: reminder_message.message("part_a").force_encoding("UTF-8") })
                puts "sent_to: #{sent_to}, phone:#{country_code}#{phone_number}, message: #{@message.body} 1/2, time: #{Time.now}"
                sleep(5)
                @message = @account.sms.messages.create({ from: "+13125488213", to: "#{country_code}#{phone_number}", body: reminder_message.message("part_b").force_encoding("UTF-8") })
                puts "sent_to: #{sent_to}, phone:#{country_code}#{phone_number}, message: #{@message.body} 2/2, time: #{Time.now}"
              else
                @message = @account.sms.messages.create({ from: "+13125488213", to: "#{country_code}#{phone_number}", body: reminder_message.message.force_encoding("UTF-8") })
                puts "sent_to: #{sent_to}, phone:#{country_code}#{phone_number}, message: #{@message.body} 1/1, time: #{Time.now}"
              end
              reminder_message.update_attribute(:status, "sent")
            rescue Twilio::REST::RequestError => err
              puts "Error sending sms to #{sent_to}: #{country_code}#{phone_number}"
              puts "* #{err}"
            end
          end
        rescue StandardError => err
          next unless defined?(ExceptionNotifier)
          ExceptionNotifier.notify_exception(
            Exception.new("SMS rake failure"),
            data: {
              reminder_message: reminder_message.try(:id),
              participant: participant.try(:id)
            }
          )
        end
      end
    end
  end
end
