class LogosController < ApplicationController

	def show
		@logo = Logo.find(params[:id])
	end

  def new
		@vendor_page = VendorPage.find(params[:vendor_page_id])
		@logo = Logo.new
  end

	def create
		@logo = Logo.create(params[:logo])
		if @logo.save
			flash[:success] = "Logo Successfully created"
			redirect_to dashboard_path
		else
			flash[:error] = "Unable to create logo"
			render "new"
		end
	end

  def edit
  end
end
