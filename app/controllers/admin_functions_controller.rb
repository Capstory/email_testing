class AdminFunctionsController < ApplicationController
  before_filter :resolve_url
  
  def dashboard
    @capsules = Capsule.all
    @clients = Client.all
    @users = User.all
    @admins = Admin.all
    @access_requests = AccessRequest.all
    @authorizations = Authorization.all
    @encapsulations = Encapsulation.all
  end
  
  private
  def resolve_url
    redirect_to "http://www.capstory.me/#{request.env["REQUEST_URI"]}" if request.env["HTTP_HOST"] == "capstory.me"
  end
end
