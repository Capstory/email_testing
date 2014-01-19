class CapsulesController < ApplicationController
  layout :resolve_layout
  before_filter :pin_code?, only: :show
  
  def index
    @capsules = Capsule.all
  end
  
  def slideshow
    @capsule = Capsule.find(params[:capsule_id])
    @slides = []
    @capsule.posts.order("created_at DESC").each do |post|
      if post.body.nil? || post.body.upcase == "NO MESSAGE" 
        @slides << post.image.url
      else
        next
      end
    end
    
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
  
  def verify_pin
  end
  
  def authenticate_pin
    provided_pin_code = params[:pin_code]
    capsule = Capsule.find(params[:capsule_id])
    if provided_pin_code == capsule.pin_code
      auth_capsule = "authenticated_capsule_#{capsule.id}"
      session[auth_capsule.to_sym] = true
      flash[:success] = "PIN Code Authenticated. Thank you."
      redirect_to capsule
    else
      flash[:error] = "Sorry, that isn't the right PIN code"
      redirect_to verify_pin_path(capsule_id: capsule.id)
    end
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
    @capsule.response_message = params[:capsule][:response_message]
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
  
  private
    def pin_code?
      capsule = Capsule.find(params[:id].to_s.downcase)
      if capsule.has_pin?
        unless pin_logged?(capsule.id)
          redirect_to verify_pin_path(capsule_id: capsule.id)
        end
      end
    end
end
