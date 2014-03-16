class VendorEmployeesController < ApplicationController
  layout "vendors"
  
  def show
    @vendor_employee = VendorEmployee.find(params[:id].to_s.downcase)
    @vendor_contact = VendorContact.new
  end
  
  def new
    @vendor = Vendor.find(params[:vendor_id])
    @vendor_employee = VendorEmployee.new
  end
  
  def create
    @vendor_employee = VendorEmployee.create do |v|
      v.name = params[:vendor_employee][:name]
      v.email = params[:vendor_employee][:email]
      
      vendor_name = Vendor.find(params[:vendor_employee][:vendor_id]).named_url
      named_url = params[:vendor_employee][:name].split(' ').join('').downcase
      
      v.named_url = "#{vendor_name}-#{named_url}"
      v.partner_code = params[:vendor_employee][:partner_code]
      v.phone = params[:vendor_employee][:phone]
      v.vendor_id = params[:vendor_employee][:vendor_id]
    end
    if @vendor_employee.save
      flash[:success] = "Vendor Salesperson Successfully Created"
      redirect_to dashboard_path
    else
      flash[:error] = "Unable to create salesperson"
      render "new"
    end
  end

  def edit
    @vendor_employee = VendorEmployee.find(params[:id])
  end
  
  def update
    @vendor_employee = VendorEmployee.find(params[:id])
    if @vendor_employee.update_attributes(params[:vendor_employee])
      flash[:success] = "Salesperson Successfully Updated"
      redirect_to dashboard_path
    else
      flash[:error] = "Unable to Update Salesperson"
      render "edit"
    end
  end
  
  def destroy
    vendor_employee = VendorEmployee.find(params[:id])
    vendor_employee.delete
    flash[:success] = "Salesperson Successfully Deleted"
    redirect_to :back
  end
end
