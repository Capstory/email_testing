class EmailRetrieversController < ApplicationController
  def activate
    email = EmailRetriever.new(params[:capsule_id])
    if email.start
      redirect_to :back
    else
      redirect_to :back
    end
  end
end
