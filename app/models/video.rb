require 'open-uri'

class Video < ActiveRecord::Base
  attr_accessible :post_id, :zencoder_url, :video
  
  has_attached_file :video
  validates_attachment_content_type :video, content_type: %w{.264 .3g2 .3gp .3gp2 .3gpp .3gpp2 .3mm .3p2 .60d .787 .89 .aaf .aec .aep .aepx .aet .aetx .ajp .ale .am .amc .amv .amx .anim .aqt .arcut .arf .asf .asx .avb .avc .avchd .avd .avi .avp .avs .avs .avv .awlive .axm .bdm .bdmv .bdt2 .bdt3 .bik .bin .bix .bmc .bmk .bnp .box .bs4 .bsf .bvr .byu .camproj .camrec .camv .ced .cel .cine .cip .clk .clpi .cmmp .cmmtpl .cmproj .cmrec .cpi .cst .cvc .cx3 .d2v .d3v .dash .dat .dav .dce .dck .dcr .dcr .ddat .dif .dir .divx .dlx .dmb .dmsd .dmsd3d .dmsm .dmsm3d .dmss .dmx .dnc .dpa .dpg .dream .dsy .dv .dv-avi .dv4 .dvdmedia .dvr .dvr-ms .dvx .dxr .dzm .dzp .dzt .edl .evo .eye .ezt .f4f .f4p .f4v .fbr .fbr .fbz .fcp .fcproject .ffd .flc .flh .fli .flv .flx .ftc .gcs .gfp .gl .gom .grasp .gts .gvi .gvp .h264 .hdmov .hdv .hkm .ifo .imovieproj .imovieproject .inp .int .ircp .irf .ism .ismc .ismclip .ismv .iva .ivf .ivr .ivs .izz .izzy .jmv .jss .jts .jtv .k3g .kdenlive .kmv .ktn .lrec .lrv .lsf .lsx .m15 .m1pg .m1v .m21 .m21 .m2a .m2p .m2t .m2ts .m2v .m4e .m4u .m4v .m75 .mani .meta .mgv .mj2 .mjp .mjpg .mk3d .mkv .mmv .mnv .mob .mod .modd .moff .moi .moov .mov .movie .mp21 .mp21 .mp2v .mp4 .mp4 .infovid .mp4v .mpe .mpeg .mpeg1 .mpeg4 .mpf .mpg .mpg2 .mpgindex .mpl .mpl .mpls .mpsub .mpv .mpv2 .mqv .msdvd .mse .msh .mswmm .mts .mtv .mvb .mvc .mvd .mve .mvex .mvp .mvp .mvy .mxf .mxv .mys .ncor .nsv .nut .nuv .nvc .ogm .ogv .ogx .orv .osp .otrkey .pac .par .pds .pgi .photoshow .piv .pjs .playlist .plproj .pmf .pmv .pns .ppj .prel .pro .pro4dvd .pro5dvd .proqc .prproj .prtl .psb .psh .pssd .pva .pvr .pxv .qt .qtch .qtindex .qtl .qtm .qtz .r3d .rcd .rcproject .rdb .rec .rm .rmd .rmd .rmp .rms .rmv .rmvb .roq .rp .rsx .rts .rts .rum .rv .rvid .rvl .sbk .sbt .scc .scm .scm .scn .screenflow .sdv .sec .sedprj .seq .sfd .sfvidcap .siv .smi .smi .smil .smk .sml .smv .snagproj .spl .sqz .srt .ssf .ssm .stl .str .stx .svi .swf .swi .swt .tda3mt .tdt .tdx .thp .tid .tivo .tix .tod .tp .tp0 .tpd .tpr .trp .ts .tsp .ttxt .tvs .usf .usm .vc1 .vcpf .vcr .vcv .vdo .vdr .vdx .veg .vem .vep .vf .vft .vfw .vfz .vgz .vid .video .viewlet .viv .vivo .vlab .vob .vp3 .vp6 .vp7 .vpj .vro .vs4 .vse .vsp .w32 .wcp .webm .wlmp .wm .wmd .wmmp .wmv .wmx .wot .wp3 .wpl .wtv .wve .wvx .xej .xel .xesc .xfl .xlmv .xmv .xvid .y4m .yog .yuv .zeg .zm1 .zm2 .zm3 .zmv}
  # validates_attachment_file_name :video, matches: [/./]
  
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
