class FacebookActionsController < ApplicationController
  def photo_push
    # raise params[:photos].to_yaml
    Resque.enqueue(FacebookPhotoPush, params[:user_id], params[:photos])
    
    flash[:success] = "Photos Processing. They should be posted to your Facebook page within a couple of seconds."
    redirect_to :back
  end
  
end