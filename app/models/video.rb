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
          :base_url => "s3://zencoder-video-output/public/#{uploaded_file.id}/videos/",
          :public => true,
          :size => "640x480",
          :apsect_mode => "pad",
          :thumbnails => {
            :number => 1,
            :format => 'jpg',
            :width => 500,
            :height => 500,
            :aspect_mode => 'crop',
            :base_url => "s3://zencoder-video-output/public/#{uploaded_file.id}/thumb/",
            :filename => "#{uploaded_file.clean_file_name}",
            :public => true
          }
        },
        {
          :filename => "#{uploaded_file.clean_file_name}.ogg",
          :base_url => "s3://zencoder-video-output/public/#{uploaded_file.id}/videos/",
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
    @post = Post.create do |post|
      post.capsule_id = options[:capsule_id]
      url = URI.parse(@details.body['job']['thumbnails'].first['url'])
      new_url = "http://" + url.host + url.path
      post.image = URI.parse(new_url)
      post.body = options[:body]
      post.email = options[:email]
			post.verified = options[:verified]
    end
    
    # Setting final parameters for video instance
    uploaded_file.zencoder_url = zjob.body['outputs'].first['url']
    uploaded_file.post_id = @post.id
    uploaded_file.save
  end
  
  def clean_file_name
    self.video_file_name.delete(Pathname.new(self.video_file_name).extname)
  end

	# Needed options
	# options[:input_url] => The url for the original file on S3
	# options[:video_filename] => the general desired filename w/o extension
	# options[:capsule_id] => The ID of the desired capsule
	# options[:body] => Default should be 'No message'
	# options[:email] => Sender email - manual should default to brad@capstory.me
	# options[:verified] => True -> the post will appear in the Capsule, False -> the post must be verified first
	#
	def	self.manually_generate_file(options={})
    video_file = Video.create
    # Create the Zencoder Job, which Zencoder than works in the background to convert and put in the specified location
    zjob = Zencoder::Job.create({
      input: options[:input_url],
      outputs: [
        {
          :filename => "#{options[:video_filename]}.mp4",
          :base_url => "s3://manual-videos/#{video_file.id}/videos/",
          :public => true,
          :size => "640x480",
          :apsect_mode => "pad",
          :thumbnails => {
            :number => 1,
            :format => 'jpg',
            :width => 500,
            :height => 500,
            :aspect_mode => 'crop',
            :base_url => "s3://manual-videos/#{video_file.id}/thumb/",
            :filename => "#{options[:video_filename]}",
            :public => true
          }
        },
        {
          :filename => "#{options[:video_filename]}.ogg",
          :base_url => "s3://manual-videos/#{video_file.id}/videos/",
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
			puts "Still working..."
			puts "Zobdy id: #{zjob.body}"
      @details = Zencoder::Job.details(zjob.body['id'])
      state = @details.body['job']['state']
      sleep 5
    end
    
    # Creating Post that will hold the video instance
    @post = Post.create do |post|
      post.capsule_id = options[:capsule_id]
      url = URI.parse(@details.body['job']['thumbnails'].first['url'])
      new_url = "http://" + url.host + url.path
      post.image = URI.parse(new_url)
      post.body = options[:body]
      post.email = options[:email]
			post.verified = options[:verified]
    end
    
    # Setting final parameters for video instance
    video_file.zencoder_url = zjob.body['outputs'].first['url']
    video_file.post_id = @post.id
    video_file.save
	end
end
