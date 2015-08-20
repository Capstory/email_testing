class CapsulesController < ApplicationController
  layout :resolve_layout
  before_filter :pin_code?, only: [:show, :angular_show]
  
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
		if params[:capsule][:email] && params[:capsule][:email].include?("@")
			temp_email = params[:capsule][:email].split("@")
			@email = temp_email.first
		else
			@email = params[:capsule][:email]
		end

    if Rails.env.production?
      @email = @email.nil? ? nil : "#{@email}@capstory.me"
    else
      @email = @email.nil? ? nil : "#{@email}@capstory-testing.com"
    end
    
		@capsule = Capsule.create(name: params[:capsule][:name], email: @email, response_message: params[:capsule][:response_message], named_url: params[:capsule][:email].to_s.downcase, event_date: params[:capsule][:event_date])
    # named_url = params[:capsule][:email].nil? ? nil : params[:capsule][:email]
    # @capsule.named_url = named_url
    if @capsule.save
      flash[:success] = "Successfully created new capsule"
      redirect_to dashboard_path
    else
      flash[:error] = "Unable to create new capsule"
      render "new"
    end
  end
  
  # def show
  #   @capsule = Capsule.find(params[:id].to_s.downcase)
		# @visible_posts = [ @capsule.id, @capsule.posts.verified.pluck(:id) ]
  #   @posts = @capsule.posts.verified.order("created_at DESC").page(params[:page]).per_page(10)
  #   @post = Post.new
  # end

	def show
    @capsule = Capsule.find(params[:id].to_s.downcase)
    @posts = @capsule.posts.order(:id).includes(:video)
		# @visible_posts = [ @capsule.id, @capsule.posts.verified.pluck(:id) ]
		@videos = @posts.map { |p| if p.video then p.video end }.compact
		@post = Post.new

		render "angular_show", layout: "angular_capsule"
	end	
	
	def angular_show
    @capsule = Capsule.find(params[:id].to_s.downcase)
    @posts = @capsule.posts.order(:id).includes(:video)
		# @visible_posts = [ @capsule.id, @capsule.posts.verified.pluck(:id) ]
		@videos = @posts.map { |p| if p.video then p.video end }.compact
		@post = Post.new

		render "angular_show", layout: "angular_capsule"
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
  # Conference Mobile View - Pure Romance
  # =====================================
  
	def	conference_capsule
		@capsule = Capsule.find(params[:id].to_s.downcase)
	end

	def	conference_filepicker_upload
		@capsule = Capsule.find(params[:capsule_id].to_s.downcase)
		
		@time_group_options = []
		JSON.parse(@capsule.time_group).each do |key, value|
			@time_group_options << [value, key]
		end
		@post = Post.new
	end

	def conference_filepicker_process
		# raise params[:post].to_yaml
		Resque.enqueue(FilepickerUpload, params[:post][:filepicker_url], params[:post][:capsule_id], params[:post][:capsule_requires_verification], params[:post][:time_group])	

		flash[:success] = "Photos submitted. Processing has started."
		redirect_to :back
	end
	
	def	conference_get_posts
		@posts = Capsule.find(params[:id]).posts.verified

		respond_to do |format|
			format.json {
				render json: @posts
			}
		end
	end

	def	conference_get_new_posts
		@capsule = Capsule.find(params[:capsule_id])
		@posts = @capsule.posts.verified.where("id > ?", params[:after_id].to_i)

		respond_to do |format|
			format.json {
				render json: @posts
			}
		end
	end
  
  # =====================================
  # Begin non-standard controller actions
  # =====================================
  
	def get_post_indexes
		post_ids = params[:post_ids].split(",").map(&:to_i)
		capsule = Capsule.find(params[:capsule_id])
		result_object = {}
		capsule.posts.each_with_index do |post, index|
			if post_ids.include?(post.id)
				selection_index = post_ids.index(post.id)
				result_object[post_ids[selection_index]] = index + 1
			end
		end

		respond_to do |format|
			format.json { render json: result_object, status: :ok }
		end
	end

  def slideshow
    @capsule = Capsule.find(params[:capsule_id])
    @slides = []
    @capsule.posts.verified.order("created_at DESC").each do |post|
      if post.body.nil? || post.body.upcase == "NO MESSAGE" 
        @slides << post.image.url(:lightbox_width)
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

			target_path = JSON.parse(params[:target_path])
      redirect_to :action => target_path["action"], id: target_path["id"]
    else
      flash[:error] = "Sorry, that isn't the right PIN code"
      redirect_to verify_pin_path(capsule_id: capsule.id, target_path: JSON.parse(params[:target_path]))
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
		when "conference_capsule"
			"conference_capsule"
		when "conference_filepicker_upload"
			"conference_capsule"
    else
      "capsules"
    end
  end

	def styles_chooser
		@capsule = Capsule.find(params[:capsule_id])
		render "styles_chooser", layout: "admin_functions"
	end

	def update_styles
		capsule = Capsule.find(params[:capsule_id])
		capsule.update_styles(params)
	
		if capsule.save
			respond_to do |format|
				format.json { render json: { msg: "Capsule Styles Updated" }, status: :ok }	
			end
		else
			respond_to do |format|
				format.json { render json: { msg: "Unable to save styles" }, status: :not_accpetable }
			end
		end
	end
  
	def export
		require "csv"

		capsule = Capsule.includes(:posts).find(params[:capsule_id])

		csv_array = CSV.generate do |csv|
			csv << ["Capsule Name", "Number of Submissions", "Capsule Email"]
			csv << [capsule.name, capsule.posts.length, capsule.email]
			csv << [""]
			csv << ["Submission Time", "Submission Source"]

			capsule.posts.each do |post|
				email = post.filepicker_url ? "Direct upload" : post.email
				acc = [post.created_at.to_formatted_s(:long), email]
				csv << acc	
			end
		end

		send_data(csv_array, filename: "#{ capsule.name.split.join("_") }_capsule_export.csv")
	end

	def vdp_export
		capsule = Capsule.find(params[:capsule_id])
		# posts = capsule.posts.order(id: :asc).take(VDP_FORMAT.data[:meta][:no_of_images])		
		posts = capsule.posts.where(verified: true, tag_for_deletion: false).reverse_order.take(VDP_FORMAT.data[:meta][:no_of_images])

		Axlsx::Package.new do |p|
			p.workbook.add_worksheet(name: "Album Export") do |sheet|
				sheet.add_row VDP_FORMAT.build_header_row				

				content_row = []

				example_names = { bride: "Jane Doe", groom: "John Doe", title: capsule.name }
				random_cover_images = VDP_FORMAT.data[:meta][:images].sample(VDP_FORMAT.data[:meta][:cover_images].length)

				VDP_FORMAT.data[:meta][:cover_images].each_with_index do |num, i|
					content_row[num - 1] = posts[random_cover_images[i]].image.url
				end

				VDP_FORMAT.data[:meta][:names].each do |name, i|
					content_row[i - 1] = example_names[name]
				end

				VDP_FORMAT.data[:meta][:images].each_with_index do |num, i|
					content_row[num - 1] = posts[i].image.url		
				end

				sheet.add_row content_row

				content_row.each_with_index do |el, i|
					sheet.add_hyperlink(location: el, ref: sheet.rows[1].cells[i]) unless el.nil?
				end
			end

			@file_path = Tempfile.new("my_export.xlsx")
			p.serialize(@file_path)
		end

		send_file(@file_path, filename: "vdp_export.xlsx", type: "application/xlsx")
	end

  private
    def pin_code?
      capsule = Capsule.find(params[:id].to_s.downcase)
      if capsule.has_pin?
        unless pin_logged?(capsule.id)
          redirect_to verify_pin_path(capsule_id: capsule.id, target_path: request.path_parameters)
        end
      end
    end
end
