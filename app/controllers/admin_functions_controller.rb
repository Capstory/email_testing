class AdminFunctionsController < ApplicationController
  before_filter :admin_authentication
  
  def dashboard
    @capsules = Capsule.all
    @clients = Client.all
    @users = User.all
    @admins = Admin.all
    @access_requests = AccessRequest.all
    @authorizations = Authorization.all
    @encapsulations = Encapsulation.all
    @vendor_pages = VendorPage.all
		@vendors = Vendor.all
		@discounts = Discount.all
  end

	def metrics
		@capsules = Capsule.clients
	end

	def	customer_new
		if ( params.has_key?(:vendor_id) && !params[:vendor_id].blank? )
			@vendor = Vendor.find(params[:vendor_id])
			@client = @vendor.clients.new 
		else
			@client = Client.new
		end
	end
	
	def	customer_create
		@client = Client.create(params[:client])
		if @client.save
			flash[:success] = "Client Created"
			redirect_to customer_capsule_new_path(client_id: @client.id)
		else
			flash[:error] = "Unable to Create Client"
			render "customer_new"
		end
	end

	def	customer_capsule_new
		@client_id = params[:client_id]
		@capsule = Capsule.new
	end

	def customer_capsule_create
    if Rails.env.production?
      email = params[:capsule][:email].nil? ? nil : "#{params[:capsule][:email].strip}@capstory.me"
    else
      email = params[:capsule][:email].nil? ? nil : "#{params[:capsule][:email].strip}@capstory-testing.com"
    end
    @capsule = Capsule.create(name: params[:capsule][:name], email: email, response_message: params[:capsule][:response_message], event_date: params[:capsule][:event_date])
    named_url = params[:capsule][:email].nil? ? nil : params[:capsule][:email]
    @capsule.named_url = named_url
		if @capsule.save
			@encap = Encapsulation.create(user_id: params[:capsule][:client_id], capsule_id: @capsule.id, owner: true ) 
			flash[:success] = "Capsule Created"
			redirect_to customer_authorization_new_path(client_id: @encap.user_id )
		else
			raise @capsule.to_yaml
			flash[:error] = "Unable to create capsule. Try Again"
			redirect_to customer_capsule_new_path(client_id: params[:capsule][:client_id])
		end
	end

	def customer_authorization_new
		@client = Client.find(params[:client_id])
	end

	def	manage_capsule
		@capsule = Capsule.find(params[:capsule_id])
	end

	def change_capsule_status
		@capsule = Capsule.find(params[:capsule_id])
		case params[:capsule_action]
		when "lock"
			@capsule.locked = true
		when "unlock"
			@capsule.locked = false
		end
		if @capsule.save
			flash[:success] = "Capsule status changed"
			redirect_to :back
		else
			flash[:error] = "Unable to change the capsule status."
			redirect_to :back
		end
	end

	def remote_moderation
		# @capsule = Capsule.find(params[:id].to_s.downcase)
		@posts = Post.order("created_at DESC").limit(50)
		render "remote_moderation", layout: "remote_moderation"
	end

	def remote_moderation_delete
		post = Post.find(params[:post_id])
		post.tag_for_deletion = true
		if post.save
			respond_to do |format|
				format.json { render json: { success: post.id, status_code: 200 } }
			end
		else
			respond_to do |format|
				format.json { render json: { error: post.id, status_code: 404 } }
			end
		end

		# respond_to do |format|
		# 	format.json { render json: {success: "here we go"}, status: 304 }
		# end
	end

	def remote_moderation_undelete
		post = Post.find(params[:post_id])
		post.tag_for_deletion = false
		if post.save
			respond_to do |format|
				format.json { render json: { success: post.id, status_code: 200 } }
			end
		else
			respond_to do |format|
				format.json { render json: { error: post.id, status_code: 404 } }
			end
		end
	end

	def remote_moderation_new_posts
		posts = Post.where("id > ?", params[:after_id])

		respond_to do |format|
			format.json { render json: posts }
		end
	end

	def remote_moderation_verify_post
		post = Post.find(params[:post_id])
		post.verified = true
		if post.save
			respond_to do |format|
				format.json { render json: { success: post.id, status_code: 200 } }
			end
		else
			respond_to do |format|
				format.json { render json: { error: post.id, status_code: 404 } }
			end
		end
	end
end
