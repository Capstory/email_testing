class VendorContactsController < ApplicationController
  
  def create
    @vendor = params[:vendor_contact][:vendor_type].constantize.find(params[:vendor_contact][:vendor_id])
    @contact = @vendor.vendor_contacts.create do |vc| 
      vc.name = params[:vendor_contact][:name]
      vc.email = params[:vendor_contact][:email]
      vc.vendor_code = params[:vendor_contact][:vendor_code]
      vc.address_1 = params[:vendor_contact][:address_1]
      vc.address_2 = params[:vendor_contact][:address_2]
      vc.message = params[:vendor_contact][:message]
      vc.phone = params[:vendor_contact][:phone]
    end
    if @contact.save
      VendorContactMailer.vendor_contact_form(@contact).deliver
      flash[:success] = "Thank you. We will be in touch very soon."
      redirect_to :back
    else
      flash[:error] = "Sorry, there was a problem. Please, try again."
      redirect_to :back
    end
  end
end
