class EmailEngine 
  @queue = :email_retrievers_queue
  
  def self.perform
    # email = EmailRetriever.new
    # email.start
    puts "I'm checking the email right now!"
  end
end