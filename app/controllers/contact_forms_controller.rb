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
		respond_to do |format|
			if @contact_form.save
				ContactFormMailer.admin_notification(@contact_form).deliver
				format.html { redirect_to contact_thank_you_path(email: @contact_form.email) }
				format.js { render status: :ok }
			else
				flash[:error] = "Unable to send message. Please, try again."
				format.html { render "new" }
				format.js { render status: :unprocessable_entity } 
			end
		end
  end
  
  def thank_you
  end
end
