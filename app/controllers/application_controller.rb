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
			if !current_user.admin?
				flash[:error] = "You are not authorized to access this area"
				redirect_to current_user
			end
    else
      flash[:error] = "Please Login First"
      redirect_to login_path
    end
  end
  
  def vendor_authentication
    if current_user
			if !current_user.vendor?
				flash[:error] = "You are not authorized to access this area"
				redirect_to current_user
			end
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
    if Rails.env.production?
      if request.env["HTTP_HOST"] == "capstory.me" || request.env["HTTP_HOST"] == "capstory.com" || request.env["HTTP_HOST"] == "www.capstory.com"
        redirect_to "http://www.capstory.me#{request.env["REQUEST_URI"]}"
      end
    end
  end

  def resolve_logo_route
    if cookies[:test_program_visit]
      cookie_value = JSON.parse(cookies[:test_program_visit])
      test_visit = TestProgramVisit.find_by_ip_address_and_id(cookie_value.first, cookie_value.last)
      case test_visit.test_version
      when "1"
        logo_route = "a_path"
      when "2"
        logo_route = "b_path"
      when "3"
        logo_route = "c_path"
      end
    else
      logo_route = "root_url"
    end    

    return logo_route
  end
  helper_method :resolve_logo_route
end
