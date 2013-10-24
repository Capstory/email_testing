class AccessRequestsController < ApplicationController
  #before_filter :admin_authentication
  
  def index
    @access_requests = AccessRequest.all
    @client = Client.new
    @identity = session[:identity]
  end
  
  def create
    @access_request = AccessRequest.create(params[:access_request])
    if @access_request.save
      redirect_to thank_you_path(request_id: @access_request.id)
    else
      flash[:error] = "There was a problem trying to log your request. Please, try again."
      redirect_to root_url
    end
  end
  
  def show
    @access_request = params[:access_request_id] ? AccessRequest.find(params[:access_request_id]) : AccessRequest.find(params[:id])
  end
end
