class EmailRetrieversController < ApplicationController
  def activate
    email = EmailRetriever.new(params[:capsule_id], params[:capsule_email])
    if email.start
      redirect_to :back
    else
      redirect_to :back
    end
  end
end
