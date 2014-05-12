require 'rubygems'
require 'twilio-ruby'

namespace :sms do
  desc "TODO"
  task random_time: :environment do
        logger = Logger.new('text.log')
        logger.info "Begin Rake #{Time.now}"
        @account_sid = 'AC41d2ef1525028bfd926a9ed9981dfc34'
        @auth_token = '1f8f5b6852e27a773b427b9e6e211b71'
        @client = Twilio::REST::Client.new(@account_sid, @auth_token)
        
        @account = @client.account
        
        users = TextUser.where(:active => true)
        users.each do |user|
           
            @message = @account.sms.messages.create({:from => '+13125488213', :to => "+#{user.phone}", :body => "Can you OA KNEE? http://mohrlab.northwestern.edu/lab/schnitzer/?user_id=#{user.handle}"})
            logger.info "user: #{user.handle}, phone:#{user.phone}, message: #{@message.body}, time: #{Time.now}"
             
        end
  end

end