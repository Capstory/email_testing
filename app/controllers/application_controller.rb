class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def admin_authentication
    if current_user
      redirect_to login_path unless current_user.admin?
    else
      flash[:error] = "Please Login First"
      redirect_to login_path
    end
  end
end
