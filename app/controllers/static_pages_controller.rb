class StaticPagesController < ApplicationController
  
  def home
		@contact_form = ContactForm.new
		render "home", layout: "ovni_layout"
  end

	def new_home
		@contact_form = ContactForm.new
		render "new_home", layout: "new_landing"
	end

	def bootstrap_home
		@contact_form = ContactForm.new
		render "bootstrap_home", layout: "new_landing"
	end
  
  def login
  end
  
  def thank_you
    @access_request = AccessRequest.find(params[:request_id])
  end

	def terms_of_use
		render "legal", layout: "application"
	end

	def privacy_policy
		render "legal", layout: "application"
	end

	def code_for_a_cause
		@event_application = EventApplication.new
		render "code_for_a_cause", layout: "ovni_layout"
	end
  
	def corporate_page
		@contact_form = ContactForm.new
		render "corporate_page", layout: "ovni_layout"
	end

	def americheer_landing
		@contact_form = ContactForm.new
		render "americheer_landing", layout: "ovni_layout"
	end

	def receptions_landing
		@contact_form = ContactForm.new
		render "new_receptions_landing", layout: "ovni_layout"
	end
end
