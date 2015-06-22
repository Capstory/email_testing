module AlbumOrdersMailerHelper
	extend ActionView::Helpers::NumberHelper

	def equal_signs

	end

	def self.print_shipping_address(order)
		address = order.address

		%Q{

			Shipping Details
			#{ (1..15).reduce("=") { |acc, n| acc + "=" } }

			Name: #{ address["full_name"] }
			Email: #{ order.email }

			#{ address["shipping_address_1"] }	
			#{ address["shipping_address_2"] }
			#{ address["shipping_city"] }, #{ address["shipping_state"] } #{ address["shipping_zip"] }
			
		}
	end

	def self.print_billing_address(order)
		address = order.address

		%Q{
			
			Billing Address
			#{ (1..15).reduce("=") { |acc, n| acc + "=" } }
			
			#{ address["billing_address_1"] }
			#{ address["billing_address_2"] }
			#{ address["billing_city"] }, #{ address["billing_state"] } #{ address["billing_zip"] }

		}
	end

	def self.print_billing_details(order)
		info = order.customer_info

		%Q{
			
			Billing Details
			#{ (1..15).reduce("=") { |acc, n| acc + "=" } }
			
			Card Number (Last 4): **** **** **** #{ info["last_4"] }
			Card Type: #{ info["card_type"] }
			Card Expiration: #{ info["card_expiration"] }

		}
	end

	def self.print_capsule(order)
		contents = order.contents

		%Q{
			
			Team
			#{ (1..15).reduce("=") { |acc, n| acc + "=" } }

			#{ contents["capsule_name"].titleize }

		}
	end

	def self.print_order_details(order)

		quantities = order.quantities

		%Q{
			
			Order Details
			#{ (1..15).reduce("=") { |acc, n| acc + "=" } }

			Hard Cover Quantity: #{ quantities["hard_covers"]["quantity"] }
			Hard Cover Total: #{ number_to_currency quantities["hard_covers"]["total"] }

			Soft Cover Quantity: #{ quantities["soft_covers"]["quantity"] }
			Soft Cover Total: #{ number_to_currency quantities["soft_covers"]["total"] }

		}		
	end
end

