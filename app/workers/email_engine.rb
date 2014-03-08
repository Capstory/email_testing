class EmailEngine 
  @queue = :email_retrievers_queue
  
  def self.perform
    if Resque.info[:pending] < 15
      email = EmailRetriever.new
      email.start
      # puts "I'm checking the email right now!"
    else
      ResqueErrorMailer.send_notification.deliver
    end
  end
end