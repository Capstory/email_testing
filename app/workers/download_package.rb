require 'zip'

class DownloadPackage
	@queue = :download_packages_queue
  @@temp_files = []
	
	def	self.perform(photos, capsule_id, download_id)
		puts "Working"
		puts "Capsule ID: #{capsule_id}"
		puts "Download ID: #{download_id}"

    s3 = AWS::S3.new
    bucket = s3.buckets["download-manager-files"]

    temp_dir = Dir.mktmpdir
    zip_path = File.join(temp_dir, "image_download_#{Time.now}.zip")
    # zip_path = "#{Rails.root}/public/image_downloads/image_download_#{Date.today.to_s}.zip"
    
    Zip::File.open(zip_path, Zip::File::CREATE) do |zipfile|
      photos.keys.each_with_index do |photo_id, index|
        title = "image_#{ index + 1 }.jpg"
        url = Post.find(photo_id).image.url(:original)
        data = open(url).read

        temp_filename = "#{Rails.root}/tmp/image_file_#{index+1}"
        @@temp_files << temp_filename
        
        temp_file = File.new(temp_filename, "wb")
        temp_file.write data
        temp_file.close
        
        zipfile.add(title, temp_file.path)
      end
    end

    date_component = Date.today.to_formatted_s(:rfc822).split
    capsule_id = capsule_id
    basename = "capstory_download_#{capsule_id}_#{date_component.join('_')}.zip"
    object = bucket.objects[basename]
    object.write(file: zip_path)
    
		download = DownloadManager.find(download_id)
    download.file_path = object.url_for(:read, expires_in: 60.minutes, use_ssl: true, response_content_disposition: "attachment/zip").to_s
    
		download.save	
	end

	def after_perform_clean_up_temp_files
		if @@temp_files.length > 0
			@@temp_files.each { |file| File.delete(file) if File.exists?(file) }
		end
	end
end
