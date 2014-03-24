class ContactFormsController < ApplicationController
  before_filter :admin_authentication, only: :index
  
  def index
    @contact_forms = ContactForm.all
  end

  def new
    @contact_form = ContactForm.new
  end
  
  def create
    @contact_form = ContactForm.create(params[:contact_form])
    if @contact_form.save
      ContactFormMailer.admin_notification(@contact_form).deliver
      redirect_to contact_thank_you_path(email: @contact_form.email)
    else
      flash[:error] = "Unable to send message. Please, try again."
      render "new"
    end
  end
  
  def thank_you
  end
end
