class VendorsController < ApplicationController

	def show
		@vendor = Vendor.find(params[:id])
		@new_order = VendorOrder.new
	end

  def new
    @vendor = Vendor.new
  end
  
  def create
		@vendor = Vendor.create(params[:vendor])
    if @vendor.save
      flash[:success] = "Vendor Successfully Created"
      redirect_to dashboard_path
    else
      flash[:error] = "Unable to create Vendor. Try again."
      render "new"
    end
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end
  
  def update
    @vendor = Vendor.find(params[:id])
    if @vendor.update_attributes(params[:vendor])
      flash[:success] = "Vendor Successfully Updated"
      redirect_to dashboard_path
    else
      flash[:error] = "Unable to update Vendor"
      render "edit"
    end
  end
  
  def destroy
    vendor = Vendor.find(params[:id])
    vendor.delete
    flash[:success] = "Vendor Successfully Deleted"
    redirect_to :back
  end
end
