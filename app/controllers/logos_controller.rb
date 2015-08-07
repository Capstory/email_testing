class LogosController < ApplicationController

	def show
		@logo = Logo.find(params[:id])
	end

  def new
		if application_classes.include?(params[:klass])
			@associated_object = params[:klass].constantize.find(params[:associated_object_id])
		else
			@associated_object = VendorPage.find(params[:associated_object_id])
		end
		@logo = Logo.new
  end

	def create
		@logo = Logo.create(params[:logo])
		if @logo.save
			flash[:success] = "Logo Successfully created"
			redirect_to dashboard_path
		else
			flash[:error] = "Unable to create logo"
			render "new"
		end
	end

  def edit
  end

	def update
		@logo = Logo.find(params[:logo_id])
		@logo.width = params[:width]
		@logo.height = params[:height]
		@logo.padding_top = params[:padding_top].to_i
		@logo.padding_left = params[:padding_left].to_i

		if @logo.save
			respond_to do |format|
				format.json { render json: @logo }
			end
		else
			respond_to do |format|
				format.json { render json: { "status" => "unable to save" } }
			end
		end
	end

	def destroy
		logo = Logo.find(params[:id])
		logo.delete
		flash[:success] = "Logo successfully deleted"
		redirect_to :back
	end
end
