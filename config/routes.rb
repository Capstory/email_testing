class SiteConstraints
  def matches?(request)
    request.session[:user_id].present?
  end
end

class PureRomanceConstraints
	def matches?(request)
		url = request.env["REQUEST_URI"]
		request_parts = url.split("/")
		
		capsules = ["chriswc", "pattywc", "pureromancewc"]
		
		if capsules.include?(request_parts.last.to_s.downcase)
			return true
		else
			return false
		end
	end
end

# class CodeForACauseConstraints
# 	def matches?(request)
# 		if request.subdomain.present?
# 			request.subdomain == "codeforacause"
# 		else
# 			return false
# 		end
# 	end
# end

class AmericheerConstraints
	def matches?(request)
		if request.subdomain.present?
			request.subdomain == "americheer"
		else
			return false
		end
	end
end

class ReceptionsConstraints
	def matches?(request)
		if request.subdomain.present?
			request.subdomain == "receptionsinc"
		else
			return false
		end
	end
end

class CorporateConstraints
	def matches?(request)
		if request.subdomain.present?
			request.subdomain == "corporate"
		else
			return false
		end
	end
end

EmailTesting::Application.routes.draw do
	# match "orders/northpointe" => "album_orders#northpointe"
	# match "orders/billing" => "album_orders#order_details"
	# resources :album_orders, path: "orders"

	scope "/orders" do
		match "northpointe" => "album_orders#northpointe"
		match "billing" => "album_orders#billing"
		match "quantity" => "album_orders#quantity"
		match "details" => "album_orders#order_details"
		match "confirmation" => "album_orders#order_confirmation"
		match "thank_you" => "album_orders#thank_you"
		match "already_paid" => "album_orders#already_paid"
		match "export" => "album_orders#export_to_xlsx"
		post "upload" => "album_orders#upload"
		put "update_status" => "album_orders#update_status"
		put "delete_file" => "album_orders#delete_upload"
		resources :album_orders
	end

	match "" => "static_pages#americheer_landing", constraints: AmericheerConstraints.new
	match "" => "static_pages#receptions_landing", constraints: ReceptionsConstraints.new
	match "" => "static_pages#corporate_page", constraints: CorporateConstraints.new
	# match "" => "static_pages#code_for_a_cause", constraints: CodeForACauseConstraints.new

  match "test_program/:test_version" => "test_program_visits#create"
  match "update_test_program_visit" => "test_program_visits#update"
  match "reset_cookie" => "test_program_visits#admin_reset_cookie"
  match "test_program_stats" => "test_program_visits#index"


  match "dashboard" => "admin_functions#dashboard"
	get "admin/metrics" => "admin_functions#metrics"
	match "manage_capsule" => "admin_functions#manage_capsule"
	match "change_capsule_status" => "admin_functions#change_capsule_status"
	match "remote_moderation" => "admin_functions#remote_moderation"
	match "remote_moderation/mark_for_trash" => "admin_functions#remote_moderation_delete"
	match "remote_moderation/remove_from_trash" => "admin_functions#remote_moderation_undelete"
	match "remote_moderation/get_new_posts" => "admin_functions#remote_moderation_new_posts"
	match "remote_moderation/verify_post" => "admin_functions#remote_moderation_verify_post"
  
  match "create_client" => "clients#create"
  match "create_admin" => "admins#create"
  match "create_contributor" => "contributors#create"
  match "access_request_to_client" => "clients#access_request_redirect_to_client"
  
	match "customer_new" => "admin_functions#customer_new" 
	match "customer_create" => "admin_functions#customer_create"
	match "customer_capsule_new" => "admin_functions#customer_capsule_new"
	match "customer_capsule_create" => "admin_functions#customer_capsule_create"
	match "customer_authorization_new" => "admin_functions#customer_authorization_new"

  resources :users
  resources :clients
  resources :admins
  resources :contributors
  
  match "auth/facebook/callback" => "authorizations#fb_create"
  match "delete_facebook_auth" => "authorizations#fb_delete"
  match "facebook_photo_push" => "facebook_actions#photo_push"
  
  resources :authorizations
  
  match "auth/identity/callback" => "sessions#create"
  match "auth/failure" => "sessions#failure"
  match "signout" => "sessions#destroy"
  
	match "/get_post_url" => "posts#get_url"
  resources :posts
  match "slides" => "posts#slides"
	match "check_new_posts" => "posts#get_new_posts"
	match "mark_for_deletion" => "posts#mark_for_deletion"
  
  match "retrieve_emails" => "email_retrievers#activate"
  
  resources :encapsulations

	match "conference_capsule/:id" => "capsules#conference_capsule"
	match "conference_get_posts" => "capsules#conference_get_posts"
	match "conference_get_new_posts" => "capsules#conference_get_new_posts"
	match "conference_upload/:capsule_id" => "capsules#conference_filepicker_upload"
	match "conference_filepicker_process" => "capsules#conference_filepicker_process"
	match "angular/:id" => "capsules#angular_show"
  resources :capsules, except: :index
  
  match 'verify_pin' => "capsules#verify_pin"
  match 'pin_authentication' => "capsules#authenticate_pin"
  match 'slideshow' => "capsules#slideshow"
  match 'reload' => "capsules#reload"
  if Rails.env.production?
    match "/reynoldslovestory" => "capsules#show", id: 7
    match "/demo" => "capsules#show", id: 8
    match "/misplaced" => "capsules#show", id: 12
  else
    match "/reynoldslovestory" => "capsules#show", id: 3
    match "/demo" => "capsules#show", id: 3
  end

  # Static Page Routes
  # match "home" => "static_pages#home"
  match "login" => "static_pages#login"
	get "legal/terms_of_use" => "static_pages#terms_of_use"
	match "legal/privacy_policy" => "static_pages#privacy_policy"

  match 'payment' => 'charges#alt_new'
  match 'payment_thank_you' => "charges#thank_you"
  match 'payment_error' => "charges#payment_error"
	match 'alt_payment' => "charges#new"
  resources :charges do
		collection do
			post "order_details"
			post "order_confirm"
		end
	end

	match "logo_redimension" => "logos#update"
	resources :logos
	
	resources :discounts
  
	post "contact_forms/request_package_information" => "contact_forms#request_package_information"
  match "contact_thank_you" => "contact_forms#thank_you"
  resources :contact_forms, only: ["index", "create", "new"]
  
	# resources :event_applications, only: ["create"]

  match "download" => "download_managers#index"
  match "package_download" => "download_managers#activate_download"
  match "zip_download" => "download_managers#zip_download"
	match "download_link" => "download_managers#download"
	match "download_poller" => "download_managers#poll"
  resources :download_managers, only: ["index"]
  
  mount Resque::Server, at: "/resque"
	if Rails.env.development?
		mount LetterOpenerWeb::Engine, at: "email_preview/letter_opener"
	end
  
	get "/:id" => "capsules#conference_capsule", constraints: PureRomanceConstraints.new

  # ==============================
  # Default routes for Capsules based on their id number
  # Must be kept at the bottom of the page so the named-url is the first route that is found and followed
  # ==============================
  get '/:id' => "capsules#show" 

  root :to => "users#welcome", constraints: SiteConstraints.new
  
  # root :to => 'homepages#alt_first_test_landing'
  # root :to => 'homepages#alt_ovni_homepage'
	root to: "static_pages#home"

end
