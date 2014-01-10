class ClientsController < ApplicationController
  
  def index
    @clients = Client.all
  end
  
  def show
    @client = Client.find(params[:id])
    redirect_to @client.capsules.first
  end
  
  def create
    @client = Client.create do |client|
      client.name = params[:name]
      client.email = params[:email]
    end
    if @client.save
      
      # Change the access request status to show that it is validated
      access_request = AccessRequest.find_by_name_and_email_and_event_date(params[:name], params[:email], params[:event_date])
      access_request.request_status = "validated"
      access_request.save
      
      # Create an Authorization to hold the authentication and login information
      Authorization.create do |auth|
        auth.user_id = @client.id
        auth.uid = params[:uid]
        auth.provider = params[:provider]
        auth.oauth_token = params[:oauth_token]
        auth.save!
      end
      
      # Automatically create a capsule for the new client
      create_client_capsule(@client, params[:event_date])
    else
      flash[:error] = "Unable to create client or capsule"
      redirect_to :back
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