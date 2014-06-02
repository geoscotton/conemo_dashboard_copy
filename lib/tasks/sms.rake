require 'rubygems'
require 'twilio-ruby'

namespace :sms do
  desc "sends pending messages that are due"
  task message: :environment do

    puts "Begin SMS Rake #{Time.now}"
    @account_sid = 'AC41d2ef1525028bfd926a9ed9981dfc34'
    @auth_token = '1f8f5b6852e27a773b427b9e6e211b71'
    @client = Twilio::REST::Client.new(@account_sid, @auth_token)
    
    @account = @client.account
    
    reminder_messages = ReminderMessage.where(status: "pending")
    
    reminder_messages.each do |reminder_message|

      if reminder_message.notification_time <= Time.now 
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
          @message = @account.sms.messages.create({ from: "+13125488213", to: "#{country_code}#{phone_number}", body: reminder_message.message })
          puts "sent_to: #{sent_to}, phone:#{country_code}#{phone_number}, message: #{@message.body}, time: #{Time.now}"

          reminder_message.update_attribute(:status, "sent")
        rescue
          puts "error sending sms to #{sent_to}: #{country_code}#{phone_number}"
        end
      end
    end
  end
end