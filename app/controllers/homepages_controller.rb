class HomepagesController < ApplicationController
  # force_ssl if: :in_production?, only: :landing
	layout :resolve_layout
  
  def landing
    @access_request = AccessRequest.new
    @reminder = Reminder.new
    @contact_form = ContactForm.new
    @engaged_contact = EngagedContact.new
  end

	def brads_ovni_landing
		@contact_form = ContactForm.new
		render "brads_ovni_landing_photos", layout: "ovni_layout"
	end

	def dustins_ovni_landing
		@contact_form = ContactForm.new
		render "dustins_ovni_landing", layout: "ovni_layout"
	end

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
