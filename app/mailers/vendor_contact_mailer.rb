class VendorContactMailer < ActionMailer::Base
  default from: "hello@capstory.me",
          to: "hello@capstory.me"
          
  def vendor_contact_form(vendor_contact)
    @contact_info = vendor_contact
    mail(subject: "Contact from Vendor Page: Someone has a question")
  end
end