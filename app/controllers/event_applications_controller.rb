class EventApplicationsController < ApplicationController
	def create
		@event_application = EventApplication.create(params[:event_application])

		respond_to do |format|
			if @event_application.save
				EventApplicationMailer.admin_notification(@event_application).deliver
				format.js { render status: :ok}
			else
				format.js { render status: :unprocessable_entity }
			end
		end
	end
end
