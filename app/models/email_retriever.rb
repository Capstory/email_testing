class EmailRetriever
  require 'net/http'
  require 'net/imap'

  
  class AttachmentFile < Tempfile
    attr_accessor :original_filename, :content_type
  end

  def initialize(capsule_id, capsule_email)
    @host = 'secure.emailsrvr.com'
    @port = 993
    @username = capsule_email
    @password = "foobar"
    @capsule_id = capsule_id
  end

  def start
    #create imap instance and authenticate application
    imap = Net::IMAP.new(@host, @port, true)
    imap.login(@username, @password)

    #select inbox of gmail for message fetching
    imap.select('INBOX')

    #fetch all messages that has not been marked deleted
    imap.uid_search(["NOT", "SEEN"]).each do |mail|

      	message = Mail.new(imap.uid_fetch(mail, "RFC822")[0].attr["RFC822"])
        header_portion = imap.uid_fetch(mail, "ENVELOPE")[0].attr["ENVELOPE"]

      	#fetch to and from email address.. you can fetch other mail headers too in same manner.
      	from_email = header_portion.sender[0].mailbox + "@" + header_portion.sender[0].host
      	
      	# This is the key portion of the script
      	# It is here that the attachments are parsed out and uploaded
      	# The key tutorials on how to do this I found at the sites listed below
      	# http://steve.dynedge.co.uk/2010/12/09/receiving-and-saving-incoming-email-images-and-attachments-with-paperclip-and-rails-3/
      	# https://github.com/thoughtbot/paperclip
      	# https://github.com/mikel/mail
      	# Initially, I was hoping to simply use paperclip to upload the pictures
      	# In reality, I needed to have a temporary file to store the picture in and then transfer it to S3
      	
      	# S3 integration was handled here:
      	# https://devcenter.heroku.com/articles/paperclip-s3
      	
      	if message.multipart?
          if message.has_attachments?
            message.attachments.each do |attachment|
              @upload_file = AttachmentFile.new("test.jpg")
              @upload_file.binmode
              @upload_file.write attachment.body.decoded
              @upload_file.flush
              @upload_file.original_filename = attachment.filename
              @upload_file.content_type = attachment.mime_type
              
              Post.create!(body: "no message", email: from_email, image: @upload_file, capsule_id: @capsule_id)
              
              @upload_file.close
              @upload_file.unlink
            end
          end
        else
          plain_body = message.body.decoded
          
          Post.create!(body: plain_body, email: from_email, image: @upload_file, capsule_id: @capsule_id)
        end
      

    	#mark message as deleted to remove duplicates in fetching
    	imap.store(mail, "+FLAGS", [:Seen])

    end
    imap.expunge()
    #logout and close imap connection
    imap.logout()
    imap.disconnect()
    
    return true
  end
end