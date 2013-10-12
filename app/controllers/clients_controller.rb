class ClientsController < ApplicationController
  
  def index
    @clients = Client.all
  end
  
  def create
    @client = Client.new(params[:client])
    if @client.save
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
      redirect_to new_contributor_path(capsule_id: @capsule.id)
    else
      flash[:error] = "Client successfully created but unable to create capsule"
      redirect_to :back
    end
  end
end