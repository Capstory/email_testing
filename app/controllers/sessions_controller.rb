class SessionsController < ApplicationController

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    flash[:success] = "Thank you for signing in"
    redirect_to root_url
  end
  
  def destroy
    session[:user_id] = nil if session[:user_id]
    flash[:success] = "You have signed out."
    redirect_to root_url
  end
end