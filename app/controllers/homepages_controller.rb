class HomepagesController < ApplicationController
  def landing
    @access_request = AccessRequest.new
    @reminder = Reminder.new
  end
end
