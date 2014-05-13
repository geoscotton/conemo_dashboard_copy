require 'rubygems'
require 'twilio-ruby'

namespace :sms do
  desc "sends pending messages that are due"
  task message: :environment do
    logger = Logger.new('text.log')
    logger.info "Begin Rake #{Time.now}"
    @account_sid = 'AC41d2ef1525028bfd926a9ed9981dfc34'
    @auth_token = '1f8f5b6852e27a773b427b9e6e211b71'
    @client = Twilio::REST::Client.new(@account_sid, @auth_token)
    
    @account = @client.account
    
    reminder_messages = ReminderMessage.where(status: "pending")
    
    reminder_messages.each do |reminder_message|

      if reminder_message.notification_time <= Time.now 
        case reminder_message.message_type
        when "participant"
          phone_number = reminder_message.participant.smartphone.number
          sent_to = reminder_message.participant.study_identifier
        else
          phone_number = reminder_message.nurse.phone
          sent_to = reminder_message.nurse.last_name
        end
     
        @message = @account.sms.messages.create({ from: '+13125488213', to: "+#{phone_number}", body: reminder_message.message })
        logger.info "sent_to: #{sent_to}, phone:#{phone_number}, message: #{@message.body}, time: #{Time.now}"

        reminder_message.status = "sent"
        reminder_message.save
      end
    end
  end
end