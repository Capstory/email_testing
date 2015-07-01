class StaticPagesController < ApplicationController
  
  def home
    @access_request = AccessRequest.new
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

	def americheer_landing
		@contact_form = ContactForm.new
		render "americheer_landing", layout: "ovni_layout"
	end

	def receptions_landing
		@contact_form = ContactForm.new
		render "new_receptions_landing", layout: "ovni_layout"
	end
end
