class FacebookActionsController < ApplicationController
  def photo_push
    user = User.find(params[:user_id])
    fb_client = user.facebook
    params[:photos].each_value do |photo_url|
       fb_client.put_picture(photo_url)
    end
    flash[:success] = "Photos Successfully Posted!"
    redirect_to :back
  end
  

end