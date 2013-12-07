class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @capsule = Capsule.find(params[:capsule_id])
    @posts = @capsule.posts.where('id > ?', params[:after].to_i)
    
    respond_to :js
  end
  
  def slides
    @capsule = Capsule.find(params[:capsule_id])
    @slides = @capsule.posts.where('id > ?', params[:after].to_i)
    
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
    Resque.enqueue(FilepickerUpload, params[:post][:filepicker_url], params[:post][:capsule_id])

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
end
