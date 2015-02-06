class DiscountsController < ApplicationController
	
	def new
		@discount = Discount.new
	end

	def create
		@discount = Discount.create do |discount| 
			discount.campaign_name = params[:discount][:campaign_name]
			discount.amount = params[:discount][:amount].to_f
			discount.genre = params[:discount][:genre]
			discount.start_date = !params[:discount][:start_date].empty? ? Date.parse(params[:discount][:start_date]) : nil
			discount.end_date = !params[:discount][:end_date].empty? ? Date.parse(params[:discount][:end_date]) : nil
			# discount.start_date = !params[:discount][:start_date].empty? ? Date.strptime(params[:discount][:start_date], "%m-%d-%Y") : nil
			# discount.end_date = !params[:discount][:end_date].empty? ? Date.strptime(params[:discount][:end_date], "%m-%d-%Y") : nil
			discount.discount_code = params[:discount][:discount_code].downcase
		end
		if @discount.save
			flash[:success] = "Successfully created discount"
			redirect_to dashboard_path
		else
			flash[:error] = "Unable to create discount"
			render "new"
		end
	end

	def show
		@discount = Discount.find(params[:id])
	end

	def edit
		@discount = Discount.find(params[:id])
	end

	def update
		@discount = Discount.find(params[:id])
		@discount.discount_code = params[:discount][:discount_code]
		@discount.amount = params[:discount][:amount]
		@discount.campaign_name = params[:discount][:campaign_name]
		@discount.genre = params[:discount][:genre]
		@discount.start_date = params[:discount][:start_date]
		@discount.end_date = params[:discount][:end_date]
		if @discount.save
			flash[:success] = "Successfully updated the discount"
			redirect_to dashboard_path
		else
			flash[:error] = "Unable to update discount"
			render "edit"
		end
	end

	def destroy
		discount = Discount.find(params[:id])
		discount.delete
		flash[:success] = "Discount successfully deleted"
		redirect_to :back	
	end
end
