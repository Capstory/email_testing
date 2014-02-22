class VendorsController < ApplicationController
  def index
  end

  def show
    @vendor = Vendor.find(params[:id].to_s.downcase)
    @vendor_contact = VendorContact.new
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
      redirect_to @vendor
    else
      flash[:error] = "Unable to create Vendor Page. Try again."
      render "new"
    end
  end

  def edit
  end
  
  def update
    
  end
  
  def destroy
    
  end
end
