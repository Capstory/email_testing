class EmailRetrieversController < ApplicationController
  def activate
    Resque.enqueue(EmailEngine, params[:capsule_id], params[:capsule_email])
      
    redirect_to :back
  end
end
