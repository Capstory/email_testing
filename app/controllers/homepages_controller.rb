class HomepagesController < ApplicationController
  def landing
    @access_request = AccessRequest.new
    @reminder = Reminder.new
    @contact_form = ContactForm.new
  end
end
