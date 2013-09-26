class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    unless @auth = Authorization.find_from_hash(auth)
      @auth = Authorization.create_from_hash(auth, current_user)
    end
    
    session[:user_id] = @auth.user.id
    flash[:success] = "Thank you for signing in"
    redirect_to root_url
  end
  
  def destroy
    session[:user_id] = nil if session[:user_id]
    flash[:success] = "You have signed out."
    redirect_to root_url
  end
end