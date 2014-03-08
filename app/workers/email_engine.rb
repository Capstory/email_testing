class EmailEngine
  @@notification_count = {}
  @queue = :email_retrievers_queue
  
  def self.perform
    if Resque.info[:pending] < 15
      email = EmailRetriever.new
      email.start
      # puts "I'm checking the email right now!"
    else
      if @@notification_count[Date.today.to_s].blank?
        ResqueErrorMailer.send_notification.deliver
        @@notification_count[Date.today.to_s] += 1
      end
    end
  end
end