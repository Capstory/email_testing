class EmailRetriever
  require 'net/http'
  require 'net/imap'

  
  class AttachmentFile < Tempfile
    attr_accessor :original_filename, :content_type
  end

  def initialize
    @host = 'imap.gmail.com'
    @port = 993
    @username = "test.emails.capstory"
    @password = "foobar1234"
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
        
      	#fetch plain part message from multipart gmail content
      	if message.multipart?
          if message.has_attachments?
            message.attachments.each do |attachment|
              @upload_file = AttachmentFile.new("test.jpg")
              @upload_file.binmode
              @upload_file.write attachment.body.decoded
              @upload_file.flush
              @upload_file.original_filename = attachment.filename
              @upload_file.content_type = attachment.mime_type
            end
          end
        else
          plain_body = message.body.decoded
        end
      
      header_portion = imap.uid_fetch(mail, "ENVELOPE")[0].attr["ENVELOPE"]
      
    	#fetch to and from email address.. you can fetch other mail headers too in same manner.
    	from_email = from_email = header_portion.sender[0].mailbox + "@" + header_portion.sender[0].host

    	# do whatever you want to do with those data...like print it
    	Post.create!(body: plain_body, email: from_email, image: @upload_file)

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