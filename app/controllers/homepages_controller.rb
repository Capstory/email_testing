class HomepagesController < ApplicationController
  # force_ssl if: :in_production?, only: :landing
	layout :resolve_layout
  
  def landing
    @access_request = AccessRequest.new
    @reminder = Reminder.new
    @contact_form = ContactForm.new
    @engaged_contact = EngagedContact.new
  end

	def homepage
		@contact_form = ContactForm.new
		render "ovni_homepage", layout: "ovni_layout"
	end

	def alt_ovni_homepage
		@contact_form = ContactForm.new
		render "alt_ovni_homepage", layout: "ovni_layout"
	end

	def test_ovni_landing
		@contact_form = ContactForm.new
		render "ovni_landing_purchase_799", layout: "ovni_layout"
	end

	def brads_ovni_landing
		@contact_form = ContactForm.new
		render "brad_ovni_landing_photos_1499", layout: "ovni_layout"
	end

	def dustins_ovni_landing
		@contact_form = ContactForm.new
		render "dustins_ovni_landing", layout: "ovni_layout"
	end

	# def americheer_landing
	# 	@contact_form = ContactForm.new
	# 	render "americheer_landing", layout: "ovni_layout"
	# end

  def first_test_landing
    # @access_request = AccessRequest.new
    # @reminder = Reminder.new
    @contact_form = ContactForm.new
    # @engaged_contact = EngagedContact.new
  end

  def alt_first_test_landing
    # @access_request = AccessRequest.new
    # @reminder = Reminder.new
    @contact_form = ContactForm.new
    # @engaged_contact = EngagedContact.new
  end

  def second_test_landing
    @contact_form = ContactForm.new
  end

  def third_test_landing
    @contact_form = ContactForm.new    
  end

  def pricing
  end

  def buy
		@access_request = AccessRequest.new
  end
  
  def in_production?
    Rails.env.production?
  end

	private
	def resolve_layout
		case action_name
		when "alt_first_test_landing"
			"blank"
		when "pricing"
			"blank"
		when "buy"
			"blank"
		else
			"homepages"
		end
	end
end
