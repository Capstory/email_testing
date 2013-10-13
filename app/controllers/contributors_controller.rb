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
      # Still need to create an Authorization here
      # I need to figure out the flow for creating a new contributor, creating their password and getting it to them
      # 
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
    @cap_owner = Encapsulation.find_by_capsule_id_and_owner(capsule_id, true).user
    if @encapsulation.save
      flash[:success] = "Key Contributor Successfully Added"
      redirect_to @cap_owner
    else
      flash[:error] = "Unable to create connection to capsule"
      redirect_to new_contributor_path(capsule_id: capsule_id)
    end
  end
end