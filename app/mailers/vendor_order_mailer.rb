class VendorOrderMailer < ActionMailer::Base
	default from: "hello@capstory.me"

	def	admin_notification(order)
		@order = order
		mail(to: "hello@capstory.me", subject: "A Vendor has Submitted an Order")
	end
end
