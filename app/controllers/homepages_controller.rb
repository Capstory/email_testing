class HomepagesController < ApplicationController
  def landing
    @access_request = AccessRequest.new
  end
end
