class EmailEngine
  @@notification_count = {}
  @queue = :email_retrievers_queue
  
  def self.before_enqueue
    # puts "Hello World"

    if Resque.info[:pending] >= 15 && @@notification_count[Date.today.to_s].blank?
      ResqueErrorMailer.send_notification.deliver
      @@notification_count[Date.today.to_s] = 1
    end
  end
  
  def self.perform
    email = EmailRetriever.new
    email.process
    # puts "I'm checking the email right now!"
  end

	def self.show_notification_count
		p @@notification_count
	end
end
