class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @capsule = Capsule.find(params[:capsule_id])
    @posts = @capsule.posts.where('id > ?', params[:after].to_i)
    
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
    @post = Post.create do |post|
      post.filepicker_url = params[:post][:filepicker_url]
      post.capsule_id = params[:post][:capsule_id]
      post.image = URI.parse(post.filepicker_url)
    end 
    if @post.save
      flash[:success] = "Photo successfully uploaded"
      redirect_to @post.capsule
    else
      flash[:error] = "Unable to upload photo"
      redirect_to @post.capsule
    end
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
end
