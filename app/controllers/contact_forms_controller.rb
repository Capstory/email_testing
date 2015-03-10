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

	def request_package_information
		@contact_form = ContactForm.new
		@contact_form.name = params[:name].blank? ? nil : params[:name]
		@contact_form.email = params[:email].blank? ? nil : params[:email]
		@contact_form.source = "request_package_information"
		
		msg_info = {bronze_package: params[:bronze_package], silver_package: params[:silver_package], gold_package: params[:gold_package], custom_package: params[:custom_package], message: params[:message], event_date: params[:event_date]}

		@contact_form.message = ContactForm.compose_request_package_information_message(msg_info)

		respond_to do |format|
			if @contact_form.save
				format.json { render json: { status: :ok } }
			else
				format.json { render json: { status: :unable_to_save_form }, status: :unprocessable_entity } 
			end
		end
	end
end
