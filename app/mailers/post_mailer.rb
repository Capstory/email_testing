class PostMailer < ActionMailer::Base
  
  def new_post_response(sender, capsule_email, capsule_id)
    @sender_email = sender
    @capsule_email = capsule_email
    @url = "http://www.capstory.me/capsules/" + capsule_id.to_s
    
    mail(from: @capsule_email, reply_to: @capsule_email, to: @sender_email, subject: "Success!")
  end
end