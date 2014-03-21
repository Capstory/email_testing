class EngagedContactMailer < ActionMailer::Base
  default from: "hello@capstory.me"
  
  def tell_an_engaged_friend(engaged_contact)
    @engaged_contact = engaged_contact
    
    mail(to: @engaged_contact.engaged_email, reply_to: @engaged_contact.email, subject: "#{@engaged_contact.name} wants to help you remember your wedding!")
  end
end