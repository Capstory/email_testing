class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    unless @auth = Authorization.find_from_hash(auth)
      if auth[:provider] = "identity"
        @identity = Identity.find(auth[:uid])
        case @identity.genre
        when "client"
          redirect_to create_client_path(name: auth[:info][:name], email: auth[:info][:email], uid: auth[:uid], provider: auth[:provider], oauth_token: auth[:credentials][:token])
        when "admin"
          redirect_to create_admin_path(name: auth[:info][:name], email: auth[:info][:email], uid: auth[:uid], provider: auth[:provider], oauth_token: auth[:credentials][:token])
        when "contributor"
          redirect_to create_contributor_path(name: auth[:info][:name], email: auth[:info][:email], uid: auth[:uid], provider: auth[:provider], oauth_token: auth[:credentials][:token])
        end
      else
       # @auth = Authorization.create_from_hash(auth)
       flash[:error] = "Unable to complete request at this time"
       redirect_to :back
      end
    else
      session[:user_id] = @auth.user.id
      flash[:success] = "Thank you for signing in"
      redirect_to @auth.user
    end
  end
  
  def destroy
    session[:user_id] = nil if session[:user_id]
    flash[:success] = "You have signed out."
    redirect_to root_url
  end
  
  def failure
    flash[:error] = "There was a problem with the login. Please, ensure that you correctly entered your login information"
    redirect_to login_path
  end
end