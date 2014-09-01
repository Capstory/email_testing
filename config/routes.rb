class SiteConstraints
  def matches?(request)
    request.session[:user_id].present?
  end
end

class VendorPagesConstraints
  def matches?(request)
    url = request.env["REQUEST_URI"]
    request_parts = url.split("/")
    if request_parts.last.include? "-"
      return false
    else
      return true
    end
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

class MattRyanConstraints
  def matches?(request)
    subdomain = request.subdomain
    if subdomain == "mattryandj"
      return true
    else
      return false
    end
  end
end

class DemoPageConstraints
	def matches?(request)
		subdomain = request.subdomain
		if subdomain == "demo"
			return true
		else
			return false
		end
	end
end

class OhioUnionConstraints
	def matches?(request)
		subdomain = request.subdomain
		if subdomain == "ohiounion"
			return true
		else
			return false
		end
	end
end

class VendorSubdomainConstraints
	def matches?(request)
		if request.subdomain.present?
			subdomain = request.subdomain
			case subdomain
			when "www"
				return false
			when "ww"
				return false
			when "wwww"
				return false
			else
				return true
			end
		end
	end
end

EmailTesting::Application.routes.draw do

  match "" => "vendor_pages#matt_ryan", constraints: MattRyanConstraints.new
	match "" => "vendor_pages#demo", constraints: DemoPageConstraints.new
	match "" => "vendor_pages#ohiounion", constraints: OhioUnionConstraints.new
	match "" => "vendor_pages#alt_show", constraints: VendorSubdomainConstraints.new

	match "a" => "homepages#alt_first_test_landing"
  match "alt_a" => "homepages#first_test_landing"
  match "b" => "homepages#second_test_landing"
  match "c" => "homepages#third_test_landing"
  match "pricing" => "homepages#pricing"
  match "purchase" => "homepages#buy"

  match "test_program/:test_version" => "test_program_visits#create"
  match "update_test_program_visit" => "test_program_visits#update"
  match "reset_cookie" => "test_program_visits#admin_reset_cookie"
  match "test_program_stats" => "test_program_visits#index"


  match "dashboard" => "admin_functions#dashboard"
	match "manage_capsule" => "admin_functions#manage_capsule"

  # ===================================================
  # AngularJS Play Routes 
  # ===================================================
  resources :entries
  match "raffle" => "raffle#index"
  # ===================================================
  # End AngularJS Play Routes
  # ===================================================
  
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
  
  resources :posts
  match "slides" => "posts#slides"
  
  match "retrieve_emails" => "email_retrievers#activate"
  
  resources :encapsulations

	match "conference_capsule/:id" => "capsules#conference_capsule"
	match "conference_get_posts" => "capsules#conference_get_posts"
	match "conference_get_new_posts" => "capsules#conference_get_new_posts"
	match "conference_upload/:capsule_id" => "capsules#conference_filepicker_upload"
	match "conference_filepicker_process" => "capsules#conference_filepicker_process"
	match "alt_show/:id" => "capsules#alt_show"
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

  match "thank_you" => "access_requests#thank_you"
  resources :access_requests, only: ["create", "new"]
  
  match 'payment' => 'charges#new'
  match 'payment_thank_you' => "charges#thank_you"
  match 'payment_error' => "charges#payment_error"
  resources :charges
  
	# ==========================
	# Note the constraints on the partners/:id route. It is the same path as the vendor_employees#show route
	# ==========================
  match 'partners/:id' => "vendor_pages#show", constraints: VendorPagesConstraints.new
  match 'employee_index' => "vendor_pages#employee_index"
	match 'vendor_orders_index' => "vendor_orders#vendor_index"
	resources :vendors
  resources :vendor_pages
  resources :vendor_contacts
	
	match "submit_order" => "vendor_orders#new"
	match "order_confirmation" => "vendor_orders#order_thank_you"
	resources :vendor_orders, only: [:new, :index, :create, :show]

  # ==========================
  # Note that this is the same path as the vendors#show route above. Thus, must be placed below the constrained route.
  # ==========================
  match 'partners/:id' => "vendor_employees#show"
  resources :vendor_employees
  
  match "reminder_thank_you" => "reminders#thank_you"
  resources :reminders
  
  match "contact_thank_you" => "contact_forms#thank_you"
  resources :contact_forms, only: ["index", "create", "new"]
  
  match "engaged_contact_thank_you" => "engaged_contacts#thank_you"
  resources :engaged_contacts, only: ["new", "create"]
  
  match "download" => "download_managers#index"
  match "package_download" => "download_managers#activate_download"
  match "zip_download" => "download_managers#zip_download"
	match "download_link" => "download_managers#download"
	match "download_poller" => "download_managers#poll"
  resources :download_managers, only: ["index"]
  
  mount Resque::Server, at: "/resque"
  
	get "/:id" => "capsules#conference_capsule", constraints: PureRomanceConstraints.new

  # ==============================
  # Default routes for Capsules based on their id number
  # Must be kept at the bottom of the page so the named-url is the first route that is found and followed
  # ==============================
  get '/:id' => "capsules#show" 
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end

  root :to => "users#welcome", constraints: SiteConstraints.new
  
  root :to => 'homepages#alt_first_test_landing'

end
