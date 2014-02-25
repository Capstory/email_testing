class SiteConstraints
  def matches?(request)
    request.session[:user_id].present?
  end
end

EmailTesting::Application.routes.draw do



  match "dashboard" => "admin_functions#dashboard"

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
  match "home" => "static_pages#home"
  match "login" => "static_pages#login"
  match "thank_you" => "static_pages#thank_you"
  
  resources :access_requests, only: ["create", "index", "show", "new"]
  
  match 'payment' => 'charges#new'
  match 'payment_thank_you' => "charges#thank_you"
  match 'payment_error' => "charges#payment_error"
  resources :charges
	
  match 'partners/:id' => "vendors#show"  
  resources :vendors
  resources :vendor_contacts
  
  match "reminder_thank_you" => "reminders#thank_you"
  resources :reminders
  
  mount Resque::Server, at: "/resque"
  
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
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  constraints(SiteConstraints.new) do
    root :to => "users#welcome"
  end
    
  root :to => 'homepages#landing'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
