class ContributorsController < ApplicationController
  
  def index
    @contributors = Contributor.all
  end
  
  def new
    @contributor = Contributor.new
    @capsule_id = params[:capsule_id]
  end

  def create
    @contributor = Contributor.new(name: params[:contributor][:name], email: params[:contributor][:email])
    if @contributor.save
      connect_to_capsule(@contributor.id, params[:contributor][:capsule_id])
    else
      flash[:error] = "Unable to create a key contributor"
      redirect_to :back
    end
  end
  
  def show
    @contributor = Contributor.find(params[:id])
  end
  
  def connect_to_capsule(contributor_id, capsule_id)
    @encapsulation = Encapsulation.create(user_id: contributor_id, capsule_id: capsule_id)
    if @encapsulation.save
      flash[:success] = "Key Contributor Successfully Added"
      redirect_to root_url
    else
      flash[:error] = "Unable to create connection to capsule"
      redirect_to new_contributor_path(capsule_id: capsule_id)
    end
  end
end