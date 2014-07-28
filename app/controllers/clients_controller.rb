class ClientsController < ApplicationController
	before_filter :admin_authentication, except: [:show]
	before_filter :verify_client_show, only: :show
  # =====================================
  # Begin standard controller actions
  # =====================================
  
  def index
    @clients = Client.all
  end
  
  def new
    @client = Client.new
  end
  
  def create
    @client = Client.create do |client|
      client.name = params[:client][:name]
      client.email = params[:client][:email]
    end
    if @client.save
      
      # Change the access request status to show that it is validated
      
      # ***************************************
      # This will likely need to change since the workflow is no longer a question of going to an access request to a client and capsule creation
      
      # access_request = AccessRequest.find_by_name_and_email_and_event_date(params[:name], params[:email], params[:event_date])
      # access_request.request_status = "validated"
      # access_request.save
      
      # Create an Authorization to hold the authentication and login information
      # Authorization.create do |auth|
      #   auth.user_id = @client.id
      #   auth.uid = params[:uid]
      #   auth.provider = params[:provider]
      #   auth.oauth_token = params[:oauth_token]
      #   auth.save!
      # end
      
      # Automatically create a capsule for the new client
      # create_client_capsule(@client, params[:event_date])
      
      flash[:success] = "Successfully Created New Client"
      redirect_to dashboard_path
    else
      flash[:error] = "Unable to create client"
      render "new"
    end
  end
  
  def show
    @client = Client.find(params[:id])
  end
  
  def edit
    @client = Client.find(params[:id])
  end
  
  def update
    @client = Client.find(params[:id])
    @client.name = params[:client][:name]
    @client.email = params[:client][:email]
    if @client.save
      flash[:success] = "Client Successfullly Updated"
      redirect_to dashboard_path
    else
      flash[:error] = "Unable to Update Client"
      render "edit"
    end
  end
  
  def destroy
    client = Client.find(params[:id])
    client.destroy
    flash[:success] = "Client Successfully Deleted"
    redirect_to :back
  end

  # =====================================
  # Begin non-standard controller actions
  # =====================================
  
	def verify_client_show
		if current_user
			puts "Current User's ID: #{current_user.id}"
			puts "Params' ID: #{ params[:id] }"
			puts "Are the id's equal?: #{ current_user.id == params[:id].to_i }"
			if current_user.id != params[:id].to_i && !current_user.admin? 
				flash[:error] = "You are not authorized to access this area"
				redirect_to current_user
			end
		else
			flash[:error] = "Please Login First"
			redirect_to login_path
		end
	end	

  def create_client_capsule(client, event_date)
    capsule_name = client.name
    capsule_base = "A Wedding Capsule for"
    @capsule = Capsule.create(name: "#{capsule_base} #{capsule_name}", event_date: event_date)
    if @capsule.save
      @encapsulation = Encapsulation.create(user_id: client.id, capsule_id: @capsule.id, owner: true)
      @encapsulation.save
      flash[:success] = "Client and Capsule Created Successfully"
      redirect_to client_path(id: client.id)
    else
      flash[:error] = "Client successfully created but unable to create capsule"
      redirect_to :back
    end
  end
  
  def access_request_redirect_to_client
    if @client = Client.find_by_name_and_email(params[:name], params[:email])
      redirect_to @client
    else
      flash.now[:error] = "Unable to find client"
      redirect_to :back
    end
  end
end
