class CapsulesController < ApplicationController
  layout :resolve_layout
  before_filter :pin_code?, only: :show
  
  # =====================================
  # Begin standard controller actions
  # =====================================
  
  def index
    @capsules = Capsule.all
  end
  
  def new
    @capsule = Capsule.new
  end

  def create
    if Rails.env.production?
      email = params[:capsule][:email].nil? ? nil : "#{params[:capsule][:email].strip}@capstory.me"
    else
      email = params[:capsule][:email].nil? ? nil : "#{params[:capsule][:email].strip}@capstory-testing.com"
    end
    @capsule = Capsule.create(name: params[:capsule][:name], email: email, response_message: params[:capsule][:response_message])
    named_url = params[:capsule][:email].nil? ? nil : params[:capsule][:email]
    @capsule.named_url = named_url
    if @capsule.save
      flash[:success] = "Successfully created new capsule"
      redirect_to dashboard_path
    else
      flash[:error] = "Unable to create new capsule"
      render "new"
    end
  end
  
  def show
    @capsule = Capsule.find(params[:id].to_s.downcase)
    @posts = @capsule.posts.order("created_at DESC").page(params[:page]).per_page(10)
    @post = Post.new
  end
	
	def alt_show
    @capsule = Capsule.find(params[:id].to_s.downcase)
    @posts = @capsule.posts.order("created_at DESC")
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
    @capsule.name = params[:capsule][:name]
    @capsule.event_date = params[:capsule][:event_date]
    if @capsule.save
      flash[:success] = "Capsule Updated"
      redirect_to @capsule
    else
      flash[:error] = "Unable to update Capsule"
      render 'edit'
    end
  end
  
  def destroy
    capsule = Capsule.find(params[:id])
    capsule.encapsulations.each do |encap|
      encap.destroy
    end
    capsule.destroy
    flash[:success] = "Capsule Successfully Deleted"
    redirect_to :back
  end
  
  # =====================================
  # Begin non-standard controller actions
  # =====================================
  
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
  
  def resolve_layout
    case action_name
    when "slideshow"
      "slideshow"
		when "alt_show"
			"alt_capsule"
    else
      "capsules"
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
