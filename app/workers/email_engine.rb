class EmailEngine 
  @queue = :email_retrievers_queue
  
  def self.perform(capsule_id, capsule_email)
    email = EmailRetriever.new(capsule_id, capsule_email)
    email.start
  end
end