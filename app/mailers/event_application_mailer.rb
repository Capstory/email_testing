class EventApplicationMailer < ActionMailer::Base
	default to: "brad@capstory.me",
					from: "hello@capstory.me"

	def admin_notification(event_application)
		@event_application = event_application
		mail(subject: "Someone has applied to Code for a Cause")
	end

end
