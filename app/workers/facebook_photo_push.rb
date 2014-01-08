class FacebookPhotoPush
  @queue = :facebook_photo_pushes_queue
  
  def self.perform(user_id, photos)
    user = User.find(user_id)
    fb_client = user.facebook
    photos.each_value do |photo_url|
       fb_client.put_picture(photo_url)
    end
  end
end