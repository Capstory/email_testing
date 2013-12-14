class PostMailer < ActionMailer::Base
  
  def new_post_response(sender, capsule_email, capsule_link)
    @sender_email = sender
    @capsule_email = capsule_email
    @url = capsule_link.is_a?(String) ? "http://www.capstory.me/" + capsule_link : "http://www.capstory.me/capsules/" + capsule_link.to_s
    
    mail(from: @capsule_email, reply_to: @capsule_email, to: @sender_email, subject: "Success!")
  end
  
  def day_two_reminder(sender, capsule_email, capsule_link)
    @sender_email = sender
    @capsule_email = capsule_email
    @url = capsule_link.is_a?(String) ? "http://www.capstory.me/" + capsule_link.html_safe : "http://www.capstory.me/capsules/" + capsule_link.to_s
    
    mail(from: @capsule_email, reply_to: @capsule_email, to: @sender_email, subject: "Thank You!")
  end
  
  def isse_day_one(sender)
    @sender_email = sender 
    
    mail(from: "isse@capstory.me", reply_to: "isse@capstory.me", to: @sender_email, subject: "Good Morning!")
  end
  
  def isse_day_two(sender)
    @sender_email = sender 
    
    mail(from: "isse@capstory.me", reply_to: "isse@capstory.me", to: @sender_email, subject: "Good Morning!")
  end
  
  def isse_day_three(sender)
    @sender_email = sender 
    
    mail(from: "isse@capstory.me", reply_to: "isse@capstory.me", to: @sender_email, subject: "Good Morning!")
  end
end