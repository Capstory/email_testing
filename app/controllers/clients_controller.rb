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
end
