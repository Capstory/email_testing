class EmailEngine 
  @queue = :email_retrievers_queue
  
  def self.perform
    email = EmailRetriever.new
    email.start
  end
end