class VendorOrdersController < ApplicationController
	http_basic_authenticate_with name: "admin", password: "capstory2014", only: :index
	http_basic_authenticate_with name: "mattryandj", password: "djevents2014", only: :new

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

end
