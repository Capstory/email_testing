require 'zip'

class DownloadManagersController < ApplicationController
  after_filter :clean_up_temp_files, only: :download
  
  @@temp_files = []
  
  def index
    if application_classes.include?(params[:klass])
      @elements = params[:klass].constantize.find(params[:element_id])
    else
      @elements = Capsule.find(params[:element_id])
    end
    @back_url = request.env["HTTP_REFERER"]
  end
  
  def download
    s3 = AWS::S3.new
    bucket = s3.buckets["download_manager_files"]
    # bucket.exists?

    temp_dir = Dir.mktmpdir
    zip_path = File.join(temp_dir, "image_download_#{Time.now}.zip")
    # zip_path = "#{Rails.root}/public/image_downloads/image_download_#{Date.today.to_s}.zip"
    
    Zip::File.open(zip_path, Zip::File::CREATE) do |zipfile|
      params[:photos].keys.each_with_index do |photo_id, index|
        title = "image_#{ index + 1 }.jpg"
        url = Post.find(photo_id).image.url(:original)
        data = open(url).read
        
        # file_path = "#{Rails.root}/public/image_holder/#{title}"
        # images << file_path
        # File.open(file_path, "wb") do |f|
        #   f.write data
        # end
        temp_filename = "#{Rails.root}/tmp/image_file_#{index+1}"
        @@temp_files << temp_filename
        
        temp_file = File.new(temp_filename, "wb")
        temp_file.write data
        temp_file.close
        
        zipfile.add(title, temp_file.path)
      end
    end

    # basename = File.basename(zip_path)
    date_component = Date.today.to_formatted_s(:rfc822).split
    capsule_id = params[:capsule_id]
    basename = "capstory_download_#{capsule_id}_#{date_component.join('_')}.zip"
    object = bucket.objects[basename]
    object.write(file: zip_path)
    
    # @file_path = zip_path
    @file_path = object.url_for(:read, expires_in: 60.minutes, use_ssl: true, response_content_disposition: "attachment/zip")
    
    # send_file zip_path, x_sendfile: true, type: "application/zip", disposition: "attachment", filename: "image_download.zip"
    
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
  
  def clean_up_temp_files
    if @@temp_files.length > 0
      @@temp_files.each { |file| File.delete(file) if File.exists?(file) }
    end
  end
end
