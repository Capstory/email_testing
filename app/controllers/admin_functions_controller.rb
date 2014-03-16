class AdminFunctionsController < ApplicationController
  
  def dashboard
    @capsules = Capsule.all
    @clients = Client.all
    @users = User.all
    @admins = Admin.all
    @access_requests = AccessRequest.all
    @authorizations = Authorization.all
    @encapsulations = Encapsulation.all
    @vendors = Vendor.all
  end
end
