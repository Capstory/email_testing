class AccessRequestsController < ApplicationController
  #before_filter :admin_authentication
  after_filter :clear_identity_session, only: :index
  
  # =====================================
  # Begin standard controller actions
  # =====================================
  
  def index
    @access_requests = AccessRequest.all
    @client = Client.new
    @identity = session[:identity]
  end
  
  def new
    @access_request = AccessRequest.new
  end
  
  def create
    @access_request = AccessRequest.create(params[:access_request])
    @access_request.request_status = "pending"
    if @access_request.save
      AccessRequestMailer.welcome_email(@access_request).deliver
      AccessRequestMailer.admin_notification(@access_request).deliver
      redirect_to thank_you_path(request_id: @access_request.id)
    else
      flash.now[:error] = "There was a problem trying to log your request. Please, try again."
      render "new"
    end
  end
  
  def show
    @access_request = params[:access_request_id] ? AccessRequest.find(params[:access_request_id]) : AccessRequest.find(params[:id])
  end
  
  def destroy
    access_request = AccessRequest.find(params[:access_request_id])
    access_request.delete
    redirect_to :back
  end
end
