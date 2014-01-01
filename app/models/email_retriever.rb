class EmailRetriever
  require 'net/http'
  require 'net/imap'
  
  class AttachmentFile < Tempfile
    attr_accessor :original_filename, :content_type
  end

  def initialize
    @host = 'secure.emailsrvr.com'
    @port = 993
    @username = Rails.env.production? ? "submit@capstory.me" : "testing@capstory.me"
    @password = "foobar"
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
      	@sender_email = header_portion.sender[0].mailbox + "@" + header_portion.sender[0].host
      	@capsule_email = header_portion.to[0].mailbox + "@capstory.me"
      	
      	default_capsule_id = Rails.env.production? ? 12 : 3
      	@capsule_id = Capsule.exists?(email: @capsule_email) ? Capsule.find_by_email(@capsule_email).id : default_capsule_id
      	
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
      	
      	if message.multipart? && message.has_attachments?
          message.attachments.each do |attachment|
            @upload_file = AttachmentFile.new("blank.jpg")
            @upload_file.binmode
            @upload_file.write attachment.body.decoded
            @upload_file.flush
            @upload_file.original_filename = attachment.filename
            @upload_file.content_type = attachment.mime_type
            
            post_body = File.extname(attachment.filename) == ".txt" ? attachment.body.decoded : "No message"
            
            if EmailRetriever.video_formats.include?(File.extname(attachment.filename))
              Video.generate_file(@upload_file, { body: post_body, email: @sender_email, capsule_id: @capsule_id })
              # Post.create!(body: post_body, email: @sender_email, image: '#', capsule_id: @capsule_id)
            else
              Post.create!(body: post_body, email: @sender_email, image: @upload_file, capsule_id: @capsule_id)
            end
            @upload_file.close
            @upload_file.unlink
          end
        else
          plain_body = message.body.decoded
          
          Post.create!(body: plain_body, email: @sender_email, image: nil, capsule_id: @capsule_id)
        end
        
    	#mark message as deleted to remove duplicates in fetching
    	imap.store(mail, "+FLAGS", [:Seen])
      
      # Send a response to the sender
      @cap = Capsule.find(@capsule_id)
      @capsule_link = @cap.named_url.nil? ? @capsule_id : @cap.named_url
      
      @capsule_message = @cap.response_message.nil? ? EmailRetriever.default_message : @cap.response_message
       
      PostMailer.new_post_response(@sender_email, @capsule_email, @capsule_link, @capsule_message).deliver
      

    end
    imap.expunge()
    #logout and close imap connection
    imap.logout()
    imap.disconnect()
    
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