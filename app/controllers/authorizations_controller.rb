class AuthorizationsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find(session[:user_id])
    @authorization = Authorization.create(provider: auth[:provider], oauth_token: auth[:credentials][:token], uid: auth[:uid], oauth_expires_at: Time.at(auth[:credentials][:expires_at]), user_id: user.id)
    if @authorization.save
      flash[:success] = "Connection Successful"

      # I think I need to change this in order to arrive at a more advanced solution.
      # This will only work for a little while.
      # Look at note on Trello
      redirect_to user.capsules.first
    else
        flash[:error] = "Connection Unsuccessful \nprovider: #{auth[:provider]} \ntoken: #{auth['credentials']['token']} \nexpires_at: #{Time.at(auth['credentials']['expires_at'])} \nuser_id: #{user.id}"
      redirect_to :back
    end
  end
  
  def delete
    authorization = Authorization.find_by_provider_and_uid(params[:provider], params[:uid])
    authorization.delete
    redirect_to :back
  end
end