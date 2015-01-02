class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
		visible_info = JSON.parse(params[:capsule_id])
    @capsule = Capsule.find(visible_info[0])
		posts = @capsule.posts.verified.pluck(:id)
    # @posts = @capsule.posts.verified.where('id > ?', params[:after].to_i)
		posts_to_get = posts.reject { |post_id| visible_info[1].include?(post_id) }
		@posts = Post.find(posts_to_get)
		
		unless @posts.empty?
			visible_info = [visible_info[0], (visible_info[1] + posts_to_get).flatten]
			@visible_info = visible_info.to_json
		end

    respond_to do |format|
			format.js
		end
  end
  
  def slides
    @capsule = Capsule.find(params[:capsule_id])
    @slides = []
    posts = @capsule.posts.verified.where('id > ?', params[:after].to_i)
    unless posts.empty?
      posts.each { |post| @slides << post.image.url }
      @id = posts.last.id
    end
    
    respond_to :js
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @capsule = Capsule.find(params[:capsule_id])
    @post = Post.new
    
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    Resque.enqueue(FilepickerUpload, params[:post][:filepicker_url], params[:post][:capsule_id], params[:post][:capsule_requires_verification])

    flash[:success] = "Photo successfully submitted. It may take a moment to upload."
    redirect_to :back
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end


	# ================================== 
	#    NON-STANDARD METHODS
	# ==================================
	
	def get_new_posts
		currently_visible_post_ids = params[:post_ids].split(",").map(&:to_i)
		currently_tagged_for_deletion_post_ids = params[:posts_tagged_for_deletion].split(",").map(&:to_i)

		@capsule = Capsule.includes(:posts).find(params[:capsule_id])

		post_ids = @capsule.posts.pluck(:id)
		tagged_for_deletion_post_ids = @capsule.posts.where(tag_for_deletion: true).pluck(:id)

		new_post_ids = post_ids.reject { |post_id| currently_visible_post_ids.include?(post_id) }
		# new_tagged_for_deletion_post_ids = tagged_for_deletion_post_ids.reject { |post_id| currently_tagged_for_deletion_post_ids.include?(post_id) }
		new_tagged_for_deletion_post_ids = tagged_for_deletion_post_ids - currently_tagged_for_deletion_post_ids
		new_undeleted_post_ids = currently_tagged_for_deletion_post_ids - tagged_for_deletion_post_ids

		@new_posts = []
		@newly_tagged_for_deletion = []
		@newly_undeleted = []

		unless new_post_ids.empty?
			new_post_ids.each do |post_id|
				@new_posts << @capsule.posts.find(post_id)
			end
		else
			# @new_posts << @capsule.posts.first
		end

		unless new_tagged_for_deletion_post_ids.empty?
			new_tagged_for_deletion_post_ids.each do |post_id|
				@newly_tagged_for_deletion << @capsule.posts.find(post_id)
			end
		else
			# @newly_tagged_for_deletion << @capsule.posts.last
		end

		unless new_undeleted_post_ids.empty?
			new_undeleted_post_ids.each do |post_id|
				@newly_undeleted << @capsule.posts.find(post_id)
			end
		end

		respond_to do |format|
			# format.json { render json: {capsule: @capsule,posts: @posts}}
			format.json { render json: { msg: "success", new_posts: @new_posts, new_deletions: @newly_tagged_for_deletion, new_undeleted: @newly_undeleted } }
		end
	end

	def mark_for_deletion
		@post = Post.find(params[:post_id])
		@post.tag_for_deletion = true

		if @post.save
			respond_to do |format|
				format.json { render json: {success: params[:post_id] }, status: 200 }
			end
		else
			respond_to do |format|
				format.json { render json: {error: params[:post_id], msg: "Unable to mark post for deletion" }, status: 409 }
			end
		end
	end
end
