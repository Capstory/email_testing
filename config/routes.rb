class SiteConstraints
  def matches?(request)
    request.session[:user_id].present?
  end
end

EmailTesting::Application.routes.draw do
  
  match "create_client" => "clients#create"
  match "create_admin" => "admins#create"
  match "create_contributor" => "contributors#create"

  resources :users
  resources :clients
  resources :admins
  resources :contributors
  
  match "auth/:provider/callback" => "sessions#create"
  match 'auth/failure' => "sessions#failure"
  match "signout" => "sessions#destroy"
  
  resources :posts
  
  match "retrieve_emails" => "email_retrievers#activate"

  resources :capsules
  match 'slideshow' => "capsules#slideshow"
  match 'reload' => "capsules#reload"
  match "/reynoldslovestory" => "capsules#show", id: 7

  # Static Page Routes
  match "home" => "static_pages#home"
  match "login" => "static_pages#login"
  match "thank_you" => "static_pages#thank_you"
  
  resources :access_requests, only: ["create", "index", "show"]
  
  mount Resque::Server, at: "/resque"
  
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
    
  root :to => 'static_pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
