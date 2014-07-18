class AccessRequestsController < ApplicationController
  #before_filter :admin_authentication
  layout :resolve_layout
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
    @access_request = AccessRequest.create do |ar|
      ar.name = params[:access_request][:name]
      ar.email = params[:access_request][:email]
      ar.event_date = params[:access_request][:event_date]
      ar.source = params[:access_request][:source]
      ar.industry_role = params[:access_request][:industry_role]
      ar.questions = params[:access_request][:questions]
      ar.partner_code = params[:access_request][:partner_code]
      ar.request_status = "pending"
    end

    if @access_request.save
      AccessRequestMailer.welcome_email(@access_request).deliver
      AccessRequestMailer.admin_notification(@access_request).deliver
      if params[:access_request][:test_program_phaseline]
        redirect_to update_test_program_visit_path(phaseline: params[:access_request][:test_program_phaseline])
      else
        redirect_to thank_you_path(request_id: @access_request.id)
      end
    else
      flash.now[:error] = "There was a problem trying to log your request. Please, try again."
			if params[:access_request][:test_program_phaseline]
				redirect_to purchase_path(@access_request), flash: { error: "Please ensure that the name and email fields are properly filled out." }
			else
				render "new"
			end
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
  
  # =====================================
  # Begin non-standard controller actions
  # =====================================  
  
  def thank_you
    @access_request = AccessRequest.find(params[:request_id])
  end
  
  private
  def resolve_layout
    case action_name
    when "thank_you"
      "homepage_blank"
    else
      "application"
    end
  end
end
