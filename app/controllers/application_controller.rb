class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :resolve_url
  
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
  
  def capsule_owner(user_id, capsule_id)
    @encapsulation = Encapsulation.find_by_user_id_and_capsule_id(user_id, capsule_id)
    if @encapsulation.nil?
      false
    else
      @encapsulation.owner ? true : false
    end
  end
  helper_method :capsule_owner
  
  def clear_identity_session
    if @identity
      session[:identity] = nil
    end
  end
  
  def pin_logged?(capsule_id)
    auth_capsule = "authenticated_capsule_#{capsule_id}"
    if session[auth_capsule.to_sym]
      return true
    else
      return false
    end
  end
  
  def resolve_url
    redirect_to "http://www.capstory.me#{request.env["REQUEST_URI"]}" if request.env["HTTP_HOST"] == "capstory.me"
  end
end
