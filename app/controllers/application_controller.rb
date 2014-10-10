class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter :show_request_env_variables
	force_ssl if: :set_ssl_by_domain
	# before_filter :resolve_url

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
		if uri_to_redirect(request.env["HTTP_HOST"])
			redirect_to "https://www.capstory.me#{request.env['REQUEST_URI']}"
		# ============================================================
		# I need to come back to this in order to constrain the various subdomains so that only the capsules 
		# for that particular subdomain can be seen. If the capsule is not a member of the subdomain, it should 
		# be re-routed to a root url. 
		# User story ---------
		# A user, who is a customer of a vendor, wants to visit their capsule. Hence, they enter the capsule ID 
		# under the subdomain of the vendor.
		#
		# User Story ---------
		# A user, who is not a customer of a vendor, wants to visit a capsule. They enter the capsule ID under the
		# subdomain of the vendor. However, because the capsule was not order through the vendor, the user is redirected
		# the vendor's landing page. Or, do we still want them redirect to the capsule but at the standard subdomain?
		#
		# ============================================================
			# elsif subdomain_to_redirect(request.env)
		# 	redirect_to "http://#{request.env['HTTP_HOST']}"
		end
	end

	def uri_to_redirect(request_host)
		address_array = [
			"capstory.me", 
			"capstory.com",
			"www.capstory.com"
		]
		
		Rails.env.production? && address_array.include?(request_host)
	end

	def subdomain_to_redirect(request_env)
		split_host = request_env["HTTP_HOST"].split(".")
		if split_host.first != "www" && request_env["REQUEST_PATH"] != "/"
			return true
		else
			return false
		end
	end

	def show_request_env_variables
		puts "============================"
		puts "Request.env Class: #{request.env.class}"

		request.env.each do |key, value|
			puts "Key: #{key}, Value: #{value}"
		end

		puts "============================"
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

	def set_ssl_by_domain
		if in_production?	&& dot_com_domain?
			false
		elsif in_production?
			true
		else
			false
		end
	end

	def in_production?
		Rails.env.production?	
	end

	def dot_com_domain?
		if request_tld == "com"
			true
		else
			false	
		end
	end

	def request_tld
		host.split(".").last
	end
end
