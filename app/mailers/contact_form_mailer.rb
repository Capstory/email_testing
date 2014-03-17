class ContactFormMailer < ActionMailer::Base
  default to: "hello@capstory.me",
          from: "hello@capstory.me"
          
  def admin_notification(contact_form)
    @contact_form = contact_form
    mail(subject: "Someone has submitted a contact form")
  end
end