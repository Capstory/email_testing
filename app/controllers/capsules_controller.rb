class CapsulesController < ApplicationController
  layout :resolve_layout
  
  def index
    @capsules = Capsule.all
  end
  
  def slideshow
    @capsule = Capsule.find(params[:capsule_id])
  end

  def create
    @capsule = Capsule.create(name: params[:capsule][:name])
    if @capsule.save
      @encapsulation = Encapsulation.create(user_id: params[:capsule][:user_id], capsule_id: @capsule.id, owner: true)
      if @encapsulation.save
        flash[:success] = "Capsule Successfully Create"
        redirect_to @encapsulation.user
      else
        flash[:error] = "Unable to Establish Encapsulation"
        redirect_to :back
      end
    else
      flash[:error] = "Unable to Create Capsule"
      redirect_to :back
    end
  end
  
  def show
    @capsule = Capsule.find(params[:id].to_s.downcase)
    @post = Post.new
  end
  
  def reload
    @new_capsule = Capsule.find(params[:id])
    
    respond_to :js
  end
  
  def edit
    @capsule = Capsule.find(params[:id])
  end
  
  def update
    @capsule = Capsule.find(params[:id])
    named_url = params[:capsule][:email].nil? ? nil : params[:capsule][:email].split("@").first
    @capsule.email = params[:capsule][:email]
    @capsule.named_url = named_url
    if @capsule.save
      flash[:success] = "Capsule Updated"
      redirect_to @capsule
    else
      flash[:error] = "Unable to update Capsule"
      render 'edit'
    end
  end
  
  def resolve_layout
    case action_name
    when "slideshow"
      "slideshow"
    else
      "application"
    end
  end
end
