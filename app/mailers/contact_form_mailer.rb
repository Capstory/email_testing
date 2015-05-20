class ContactFormMailer < ActionMailer::Base
  default to: "hello@capstory.me",
          from: "hello@capstory.me"
          
  def admin_notification(contact_form)
    @contact_form = contact_form

		if @contact_form.source == "receptions_addon"
			mail(to: "hello@receptionsinc.com", subject: "Someone has submitted a Receptions Order")
		else
			mail(subject: "Someone has submitted a contact form")
		end
  end
end
