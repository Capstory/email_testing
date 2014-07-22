class DownloadManagersController < ApplicationController
  
  def index
    if application_classes.include?(params[:klass])
      @elements = params[:klass].constantize.find(params[:element_id])
    else
      @elements = Capsule.find(params[:element_id])
    end
    @back_url = request.env["HTTP_REFERER"]
  end

  def activate_download
		@download = DownloadManager.create
		if @download.save
			Resque.enqueue(DownloadPackage, params[:photos], params[:capsule_id], @download.id)
			@result = "success"
		else	
			@result = "error"
		end

		# #####################
		# I still need to write the JS file that will notify the poller to start
		# ####################
		respond_to :js
  end

	def poll
		download = DownloadManager.find(params[:download_id])
		if download.file_path.nil?
			@response = { "ready" => false }
		else
			@response = { "ready" => true }
		end

		respond_to do |format|
			format.json { render json: @response }
		end
	end
	
	def	download
		@file_path = DownloadManager.find(params[:download_id]).file_path
	end
  
  def zip_download
    # send_data params[:file_path], x_sendfile: true, type: "application/zip", disposition: "attachment", filename: "image_download.zip"
    redirect_to params[:file_path]
  end
  
  private
  
  def application_classes
    klasses = []
    Dir.foreach("#{Rails.root}/app/models") do |model_path|
      klasses << model_path
    end
    klasses.select! { |model_path| model_path.include?(".rb") }
    klasses.each_with_index do |model_path, index|
      klass = model_path.split(".").first
      klass = klass.include?("_") ? klass.split("_").map(&:titlecase).join("") : klass.titlecase
      klasses[index] = klass
    end
    return klasses
  end
end
