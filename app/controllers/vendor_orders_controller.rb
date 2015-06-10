class VendorOrdersController < ApplicationController
	before_filter :vendor_authentication, only: [:vendor_index, :new]
	before_filter :admin_authentication, only: :index

	def	index
		@orders = VendorOrder.all
	end

	def vendor_index
		@vendor = Vendor.find(params[:vendor_id])
		@orders = @vendor.vendor_orders
	end

	def show
		@order = VendorOrder.find(params[:id])
	end

	def	new
		@vendor_id = params[:vendor_id]
		@vendor_order = VendorOrder.new
	end
	
	def	create
		@vendor_order = VendorOrder.new(params[:vendor_order])
		@vendor_order.status = "unprocessed"
		if @vendor_order.save
			VendorOrderMailer.admin_notification(@vendor_order).deliver
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
