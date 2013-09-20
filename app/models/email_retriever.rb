class EmailRetriever
  require 'net/http'
  require 'net/imap'

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
    imap.search(["NOT", "SEEN"]).each do |mail|

    	message = Mail.new(imap.fetch(mail, "RFC822")[0].attr["RFC822"])

    	#fetch plain part message from multipart gmail content
    	plain_body = message.multipart? ? (message.text_part ? message.text_part.body.decoded : "This is a failed test") : message.body.decoded
      
      header_portion = imap.fetch(mail, "ENVELOPE")[0].attr["ENVELOPE"]
    	#fetch to and from email address.. you can fetch other mail headers too in same manner.
    	from_email = from_email = header_portion.sender[0].mailbox + "@" + header_portion.sender[0].host

    	# do whatever you want to do with those data...like print it
    	Post.create!(body: plain_body, email: from_email)

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