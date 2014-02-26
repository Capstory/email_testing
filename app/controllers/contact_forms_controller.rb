class ContactFormsController < ApplicationController
  before_filter :admin_authentication, only: :index
  
  def index
    @contact_forms = ContactForm.all
  end

  def new
    @contact_form = ContactForm.new
  end
  
  def create
    @contact = ContactForm.create(params[:contact_form])
    if @contact.save
      ContactFormMailer.admin_notification(@contact).deliver
      redirect_to contact_thank_you_path(email: @contact.email)
    else
      flash[:error] = "Unable to send message. Please, try again."
      redirect_to new_contact_form_path
    end
  end
  
  def thank_you
  end
end
