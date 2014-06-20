class VendorOrdersController < ApplicationController
	USERS = {	"admin" => "capstory2014" }
	VENDORS = { "mattryandj" => "djevents2014" }

	# before_filter :admin_authenticate, only: :index
	# before_filter :vendor_authenticate, only: :new

	def	index
		@orders = VendorOrder.all
	end

	def show
		@order = VendorOrder.find(params[:id])
	end

	def	new
		@vendor_order = VendorOrder.new
	end
	
	def	create
		@vendor_order = VendorOrder.new(params[:vendor_order])
		if @vendor_order.save
			flash[:success] = "Order Successfully Submitted"
			redirect_to order_confirmation_path
		else
			flash[:error] = "Unable to process order. Please contact the Capstory Team"
			render "new"
		end
	end

	def order_thank_you
	end

	private
	def admin_authenticate
		authenticate_or_request_with_http_digest do |username|
			USERS[username]
		end
	end

	def	vendor_authenticate
		authenticate_or_request_with_http_digest do |username|
			VENDORS[username]
		end
	end
end
