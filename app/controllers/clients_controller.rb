class ClientsController < ApplicationController
  
  def index
    @clients = Client.all
  end
  
  def show
    @client = Client.find(params[:id])
  end
  
  def create
    @client = Client.create do |client|
      client.name = params[:name]
      client.email = params[:email]
    end
    if @client.save
      Authorization.create do |auth|
        auth.user_id = @client.id
        auth.uid = params[:uid]
        auth.provider = params[:provider]
        auth.oauth_token = params[:oauth_token]
        auth.save!
      end
      create_client_capsule(@client)
    else
      flash[:error] = "Unable to create client or capsule"
      redirect_to :back
    end
  end
  
  
  def create_client_capsule(client)
    capsule_name = client.name
    capsule_base = "A Wedding Capsule for"
    @capsule = Capsule.create(name: "#{capsule_base} #{capsule_name}")
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