require 'open-uri'

class Video < ActiveRecord::Base
  attr_accessible :post_id, :zencoder_url, :video
  
  has_attached_file :video
  belongs_to :post
  
  def self.generate_file(file, options={})
    uploaded_file = Video.create(video: file)
    # Create the Zencoder Job, which Zencoder than works in the background to convert and put in the specified location
    zjob = Zencoder::Job.create({
      input: uploaded_file.video.url,
      outputs: [
        {
          :filename => "#{uploaded_file.clean_file_name}.mp4",
          :base_url => "s3://emailtestingdevvideooutput/public/#{uploaded_file.id}/videos/",
          :public => true,
          :size => "640x480",
          :apsect_mode => "pad",
          :thumbnails => {
            :number => 1,
            :format => 'jpg',
            :width => 500,
            :height => 500,
            :aspect_mode => 'crop',
            :base_url => "s3://emailtestingdevvideooutput/public/#{uploaded_file.id}/thumb/",
            :filename => "#{uploaded_file.clean_file_name}",
            :public => true
          }
        },
        {
          :filename => "#{uploaded_file.clean_file_name}.ogg",
          :base_url => "s3://emailtestingdevvideooutput/public/#{uploaded_file.id}/videos/",
          :format => 'ogg',
          :public => true,
          :size => "640x480",
          :aspect_mode => "pad"
        }
      ]
    })

    
    # Waiting until video conversion is complete
    state = "in progress"
    until state == "finished" do
      @details = Zencoder::Job.details(zjob.body['id'])
      state = @details.body['job']['state']
      sleep 5
    end
    
    # Creating Post that will hold the video instance
    # AWS.config({
    #   access_key_id: 'AKIAI32PTERUQJYBQUDA',
    #   secret_access_key: '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'
    # })
    
    @post = Post.create do |post|
      post.capsule_id = options[:capsule_id]
      url = URI.parse(@details.body['job']['thumbnails'].first['url'])
      new_url = "http://" + url.host + url.path
      post.image = URI.parse(new_url)
      post.body = options[:body]
      post.email = options[:email]
    end
    
    # Setting final parameters for video instance
    uploaded_file.zencoder_url = zjob.body['outputs'].first['url']
    uploaded_file.post_id = @post.id
    uploaded_file.save
  end
  
  def clean_file_name
    name = self.video_file_name.delete(Pathname.new(self.video_file_name).extname)
    return name
  end
end
