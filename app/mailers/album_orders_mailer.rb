class AlbumOrdersMailer < ActionMailer::Base
	# include AlbumOrdersMailerHelper

	default from: "hello@capstory.me"

	def admin_notification(order)
		@order = order

		mail(to: "hello@capstory.me", subject: "Order Submitted - Northpointe Dance")
	end

	def customer_notification(order)
		@order = order

		mail(to: @order.email, subject: "Capstory - Album Order")
	end
end
