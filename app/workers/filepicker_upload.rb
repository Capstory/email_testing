class FilepickerUpload
  @queue = :filepicker_uploads_queue
  
  def self.perform(filepicker_urls, capsule_id, time_group=nil)
    puts "Working..."
    if filepicker_urls.include?(",")
      filepicker_array = filepicker_urls.split(",")
      filepicker_array.each { |url| url.strip! }
    else
      filepicker_array = []
      filepicker_array << filepicker_urls 
    end
    filepicker_array.each do |url|
      @post = Post.create do |post|
        post.filepicker_url = url
        post.capsule_id = capsule_id
        post.image = URI.parse(post.filepicker_url)
				post.time_group = time_group
      end 
    end
    puts "Finished working."
  end
end
