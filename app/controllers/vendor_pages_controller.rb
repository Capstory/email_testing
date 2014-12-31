class VendorPagesController < ApplicationController
  layout :resolve_layout
	before_filter :register_visit, only: :alt_show 

  def show
    @vendor = VendorPage.find(params[:id].to_s.downcase)
    @vendor_contact = @vendor.vendor_contacts.new
  end

	def alt_show
		
		@vendor ||= VendorPage.find(request.subdomain)
		if @vendor.verified?
			if page = find_page_and_layout(request.subdomain)
				@contact_form = ContactForm.new
				render page[:view], layout: page[:layout]
			else
				render "alt_show", layout: "matt_ryan"
			end
		else
			@contact_form = ContactForm.new
			render "new_vendor_page", layout: "ovni_layout"
		end
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
			v.vendor_status = false
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
		# 
		# I need to add a manner of changing the vendor_status from false to true
		# once a vendor signs up
		#
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

	def ohiounion
	end

  private
  def resolve_layout
    case action_name
    when "matt_ryan"
      "matt_ryan"
		when "demo"
			"matt_ryan"
		when "ohiounion"
			"matt_ryan"
    else
      "vendor_pages"
    end
  end

	def register_visit
		if params[:visit_tag]
			# puts "=========================================="
			# puts "Remote Addr: #{request.env['REMOTE_ADDR']}"
			# puts "Server Name: #{request.env['SERVER_NAME']}"
			# puts "Remote IP: #{request.remote_ip}"
			# puts "Original URL: #{request.original_url}"
			# puts "=========================================="
			@vendor_page = VendorPage.find(request.subdomain)
			@vendor_page.page_visits.create!(remote_ip: request.remote_ip, original_url: request.original_url)	
			redirect_to "http://#{request.env["HTTP_HOST"]}"			
		# else
		# 	puts "========================================="
		# 	puts "There was no visit_tag"
		# 	puts "========================================="
		end
	end

	def find_page_and_layout(subdomain)
		pages = {
			"americheer" => {
				view: "americheer_landing",
				layout: "ovni_layout"
			},
			"receptionsinc" => {
				view: "receptions_landing",
				layout: "ovni_layout"
			}
		}

		if pages[subdomain.downcase]
			pages[subdomain.downcase]
		else
			nil
		end
	end
end
