require 'net/http'
require 'net/imap'
   
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


class EmailRetriever
  attr_accessor :host, :port, :username, :password, :imap, :default_capsule_id

  def initialize
    @host = 'secure.emailsrvr.com'
    @port = 993
    @username = Rails.env.production? ? "submit@capstory.me" : "submit@capstory-testing.com"
    @password = "foobar"
    @imap = self.imap_connection
    @default_capsule_id = Rails.env.production? ? 12 : 3
  end

  def imap_connection
    #create imap instance and authenticate application
    imap = Net::IMAP.new(self.host, self.port, true)
    return imap
  end

  def imap_login
    self.imap.login(self.username, self.password)
  end

  def select_mailbox(mailbox='INBOX')
    # For the moment, I'm manually setting the mailbox choice to INBOX but I want to allow for that to change in the future
    self.imap.select(mailbox)
  end

  def get_new_emails
    new_emails_array = self.imap.uid_search(["NOT", "SEEN"])
    return new_emails_array
  end

  def get_email_data(uid)
    return Mail.new(self.imap.uid_fetch(uid, "RFC822")[0].attr["RFC822"])
  end

  def get_email_header(uid)
    return self.imap.uid_fetch(uid, "ENVELOPE")[0].attr["ENVELOPE"]
  end

  def imap_notify(uid)
    self.imap.store(uid, "+FLAGS", [:Seen])    
  end

  def imap_close_out
    self.imap.expunge()
    self.imap.logout()
    self.imap.disconnect()
  end

  def process
    # Login to mailbox
    self.imap_login
    # Select Inbox
    self.select_mailbox

    self.get_new_emails.each do |mail|
    
			self.imap_notify(mail)
      email = Email.new(self.get_email_data(mail), self.get_email_header(mail), self.default_capsule_id)
  
			if email.capsule_accepting_submissions?
				if email.has_attachments?
					email.process_attachments
				else
					email.process_body
				end
				email.notify_sender
			else
				puts "==============================="
				puts "Unable to submit photo"
				puts "Capsule closed"
				puts "==============================="

				email.notify_sender_of_closed_capsule
			end
    end

    self.imap_close_out
    
    return true
  end
  
  def self.video_formats
   formats = %w{.264 .3g2 .3gp .3gp2 .3gpp .3gpp2 .3mm .3p2 .60d .787 .89 .aaf .aec .aep .aepx .aet .aetx .ajp .ale .am .amc .amv .amx .anim .aqt .arcut .arf .asf .asx .avb .avc .avchd .avd .avi .avp .avs .avs .avv .awlive .axm .bdm .bdmv .bdt2 .bdt3 .bik .bin .bix .bmc .bmk .bnp .box .bs4 .bsf .bvr .byu .camproj .camrec .camv .ced .cel .cine .cip .clk .clpi .cmmp .cmmtpl .cmproj .cmrec .cpi .cst .cvc .cx3 .d2v .d3v .dash .dat .dav .dce .dck .dcr .dcr .ddat .dif .dir .divx .dlx .dmb .dmsd .dmsd3d .dmsm .dmsm3d .dmss .dmx .dnc .dpa .dpg .dream .dsy .dv .dv-avi .dv4 .dvdmedia .dvr .dvr-ms .dvx .dxr .dzm .dzp .dzt .edl .evo .eye .ezt .f4f .f4p .f4v .fbr .fbr .fbz .fcp .fcproject .ffd .flc .flh .fli .flv .flx .ftc .gcs .gfp .gl .gom .grasp .gts .gvi .gvp .h264 .hdmov .hdv .hkm .ifo .imovieproj .imovieproject .inp .int .ircp .irf .ism .ismc .ismclip .ismv .iva .ivf .ivr .ivs .izz .izzy .jmv .jss .jts .jtv .k3g .kdenlive .kmv .ktn .lrec .lrv .lsf .lsx .m15 .m1pg .m1v .m21 .m21 .m2a .m2p .m2t .m2ts .m2v .m4e .m4u .m4v .m75 .mani .meta .mgv .mj2 .mjp .mjpg .mk3d .mkv .mmv .mnv .mob .mod .modd .moff .moi .moov .mov .movie .mp21 .mp21 .mp2v .mp4 .mp4 .infovid .mp4v .mpe .mpeg .mpeg1 .mpeg4 .mpf .mpg .mpg2 .mpgindex .mpl .mpl .mpls .mpsub .mpv .mpv2 .mqv .msdvd .mse .msh .mswmm .mts .mtv .mvb .mvc .mvd .mve .mvex .mvp .mvp .mvy .mxf .mxv .mys .ncor .nsv .nut .nuv .nvc .ogm .ogv .ogx .orv .osp .otrkey .pac .par .pds .pgi .photoshow .piv .pjs .playlist .plproj .pmf .pmv .pns .ppj .prel .pro .pro4dvd .pro5dvd .proqc .prproj .prtl .psb .psh .pssd .pva .pvr .pxv .qt .qtch .qtindex .qtl .qtm .qtz .r3d .rcd .rcproject .rdb .rec .rm .rmd .rmd .rmp .rms .rmv .rmvb .roq .rp .rsx .rts .rts .rum .rv .rvid .rvl .sbk .sbt .scc .scm .scm .scn .screenflow .sdv .sec .sedprj .seq .sfd .sfvidcap .siv .smi .smi .smil .smk .sml .smv .snagproj .spl .sqz .srt .ssf .ssm .stl .str .stx .svi .swf .swi .swt .tda3mt .tdt .tdx .thp .tid .tivo .tix .tod .tp .tp0 .tpd .tpr .trp .ts .tsp .ttxt .tvs .usf .usm .vc1 .vcpf .vcr .vcv .vdo .vdr .vdx .veg .vem .vep .vf .vft .vfw .vfz .vgz .vid .video .viewlet .viv .vivo .vlab .vob .vp3 .vp6 .vp7 .vpj .vro .vs4 .vse .vsp .w32 .wcp .webm .wlmp .wm .wmd .wmmp .wmv .wmx .wot .wp3 .wpl .wtv .wve .wvx .xej .xel .xesc .xfl .xlmv .xmv .xvid .y4m .yog .yuv .zeg .zm1 .zm2 .zm3 .zmv}
   return formats
  end
  
  def self.default_message
    return "Perfect! We received the images, thanks for sharing!\nPlease continue sending them in."
  end
end

class AttachmentFile < Tempfile
  attr_accessor :original_filename, :content_type
end

class Email
  attr_accessor :data, :header, :capsule_id, :post_verified

  def initialize(data, header, default_capsule_id)
    @data = data
    @header = header
    @capsule_id, @post_verified = self.set_capsule_id_and_verification_status(default_capsule_id)
  end

	def capsule_accepting_submissions?
		Capsule.find(@capsule_id).accepting_submissions?	
	end

  def set_capsule_id_and_verification_status(default_capsule_id)
    capsule_id = Capsule.exists?(email: self.capsule_email) ? Capsule.find_by_email(self.capsule_email).id : default_capsule_id
		post_verified = Capsule.find(capsule_id).requires_verification ? false : true
    return capsule_id, post_verified
  end

  def sender_email
    sender_email = self.header.sender[0].mailbox + "@" + self.header.sender[0].host
    return sender_email
  end

  def capsule_email
    if Rails.env.production?
      capsule_email = to_address_mailbox +  "@capstory.me"
    else
      capsule_email = to_address_mailbox +  "@capstory-testing.com"
    end
    return capsule_email
  end

	def to_address_mailbox
		if self.header.to[0].mailbox.nil?
			"nothing"
		else
			self.header.to[0].mailbox.downcase
		end
	end

  def has_attachments?
    if self.data.multipart? && self.data.has_attachments?
      return true
    else
      return false
    end
  end

  def process_attachments
    self.data.attachments.each do |attachment|
      if attachment.mime_type.split("/").first == "image" && attachment.body.decoded.length < 10000
        next
      elsif attachment.mime_type == "text/html"
        next
      else
        @upload_file = AttachmentFile.new("blank.jpg")
        @upload_file.binmode
        @upload_file.write attachment.body.decoded
        @upload_file.flush
        @upload_file.original_filename = attachment.filename
        @upload_file.content_type = attachment.mime_type
      
        post_body = File.extname(attachment.filename) == ".txt" ? attachment.body.decoded : "No message"
      
        if EmailRetriever.video_formats.include?(File.extname(attachment.filename))
          Video.generate_file(@upload_file, { body: post_body, email: self.sender_email, capsule_id: self.capsule_id, verified: self.post_verified })
          # Post.create!(body: post_body, email: @sender_email, image: '#', capsule_id: @capsule_id)
        elsif File.extname(attachment.filename) == ".txt"
          Post.create!(body: post_body, email: self.sender_email, capsule_id: self.capsule_id, verified: self.post_verified)
        else
          Post.create!(body: post_body, email: self.sender_email, image: @upload_file, capsule_id: self.capsule_id, verified: self.post_verified)
        end
        @upload_file.close
        @upload_file.unlink
      end
    end
  end

  def process_body
    # plain_body = self.data.body.decoded
		plain_body = self.get_body_text
          
    Post.create!(body: plain_body, email: self.sender_email, capsule_id: self.capsule_id, verified: self.post_verified)
  end

	def get_body_text
		if self.data.multipart?
			self.data.parts.first.body.decoded
		else
			self.data.body.decoded
		end
	end

  def notify_sender
    # Send a response to the sender
    cap = Capsule.find(self.capsule_id)
    capsule_link = cap.named_url.nil? ? self.capsule_id : cap.named_url
    
    capsule_message = cap.response_message.nil? ? EmailRetriever.default_message : cap.response_message
    
    if Rails.env.production?
      PostMailer.new_post_response(self.sender_email, self.capsule_email, capsule_link, capsule_message).deliver
    else
      PostMailer.new_post_response(self.sender_email, self.capsule_email, capsule_link, capsule_message).deliver
    end  
  end

	def notify_sender_of_closed_capsule
		if Rails.env.production?
			PostMailer.capsule_closed(self.sender_email, self.capsule_email).deliver
		else
			PostMailer.capsule_closed(self.sender_email, self.capsule_email).deliver
		end
	end
end
