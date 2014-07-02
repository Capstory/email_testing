class VendorPagesController < ApplicationController
  layout :resolve_layout
  
  def show
    @vendor = VendorPage.find(params[:id].to_s.downcase)
    @vendor_contact = @vendor.vendor_contacts.new
  end
  
  def employee_index
    @vendor_page = VendorPage.find(params[:vendor_page_id])
  end

  def new
    @vendor_page = VendorPage.new
  end
  
  def create
    @vendor_page = VendorPage.create do |v| 
      v.name = params[:vendor_page][:name]
      v.email = params[:vendor_page][:email]
      
      named_url = params[:vendor_page][:name].split(' ').join('').downcase
      url = named_url.include?("-") ? named_url.split('-').join('') : named_url
      
      v.named_url = url
      v.partner_code = params[:vendor_page][:partner_code]
      v.phone = params[:vendor_page][:phone]
    end
    if @vendor_page.save
      flash[:success] = "Vendor Page successfully created"
      redirect_to new_vendor_employee_path(vendor_page_id: @vendor_page.id)
    else
      flash[:error] = "Unable to create Vendor Page. Try again."
      render "new"
    end
  end

  def edit
    @vendor_page = VendorPage.find(params[:id])
  end
  
  def update
    @vendor_page = VendorPage.find(params[:id])
    if @vendor_page.update_attributes(params[:vendor_page])
      flash[:success] = "Vendor Successfully Updated"
      redirect_to dashboard_path
    else
      flash[:error] = "Unable to update Vendor"
      render "edit"
    end
  end
  
  def destroy
    vendor_page = VendorPage.find(params[:id])
    vendor_page.delete
    flash[:success] = "Vendor Successfully Deleted"
    redirect_to :back
  end

  ########################################
  ########################################

  def matt_ryan
  end

	def demo

	end

  private
  def resolve_layout
    case action_name
    when "matt_ryan"
      "matt_ryan"
		when "demo"
			"matt_ryan"
    else
      "vendor_pages"
    end
  end
end
