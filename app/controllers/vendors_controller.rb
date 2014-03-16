class VendorsController < ApplicationController
  def index
    
  end

  def show
    @vendor = Vendor.find(params[:id].to_s.downcase)
    @vendor_contact = VendorContact.new
  end
  
  def employee_index
    @vendor = Vendor.find(params[:vendor_id])
  end

  def new
    @vendor = Vendor.new
  end
  
  def create
    @vendor = Vendor.create do |v| 
      v.name = params[:vendor][:name]
      v.email = params[:vendor][:email]
      v.named_url = params[:vendor][:name].split(' ').join('').downcase
      v.partner_code = params[:vendor][:partner_code]
      v.phone = params[:vendor][:phone]
    end
    if @vendor.save
      flash[:success] = "Vendor Page successfully created"
      redirect_to new_vendor_employee_path(vendor_id: @vendor.id)
    else
      flash[:error] = "Unable to create Vendor Page. Try again."
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
