class StaticPagesController < ApplicationController
  
  def home
    @access_request = AccessRequest.new
  end
  
  def login
  end
  
  def thank_you
    @access_request = AccessRequest.find(params[:request_id])
  end
end
