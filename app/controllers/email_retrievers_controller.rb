class EmailRetrieversController < ApplicationController
  def activate
    Resque.enqueue(EmailEngine)
      
    redirect_to :back
  end
end
