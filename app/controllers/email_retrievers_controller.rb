class EmailRetrieversController < ApplicationController
  def activate
    Resque.enqueue(EmailEngine)
    
  end
end
