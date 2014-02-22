class VendorContactsController < ApplicationController
  
  def create
    @contact = VendorContact.new(params[:vendor_contact])
    if @contact.save
      VendorContactMailer.vendor_contact_form(@contact).deliver
      flash[:success] = "Thank you. We will be in touch very soon."
      redirect_to @contact.vendor
    else
      flash[:error] = "Sorry, there was a problem. Please, try again."
      redirect_to @contact.vendor
    end
  end
end
