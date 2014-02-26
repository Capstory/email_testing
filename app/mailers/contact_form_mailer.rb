class ContactFormMailer < ActionMailer::Base
  default to: ["suprasanna@capstory.me", "dustin@capstory.me", "jocelyn@capstory.me", "brad@capstory.me"],
          from: "hello@capstory.me"
          
  def admin_notification(contact_form)
    @contact_form = contact_form
    mail(subject: "Someone has submitted a contact form")
  end
end