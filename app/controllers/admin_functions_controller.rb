class AdminFunctionsController < ApplicationController
  before_filter :admin_authentication
  
  def dashboard
    @capsules = Capsule.all
    @clients = Client.all
    @users = User.all
    @admins = Admin.all
    @access_requests = AccessRequest.all
    @authorizations = Authorization.all
    @encapsulations = Encapsulation.all
    @vendor_pages = VendorPage.all
		@vendors = Vendor.all
  end
end
