class VendorOrder < ActiveRecord::Base
  attr_accessible :client_names, :email, :event_date, :requested_address, :requested_upgrades, :shipping_1, :shipping_2, :shipping_city, :shipping_state, :shipping_zip, :vendor_id, :status

	belongs_to :vendor

	def status_class
		case self.status
		when "unprocessed"
			return "alert-box warning"
		when "processed"
			return "alert-box success"
		else
			return "alert-box info"
		end
	end

	def show_status
		case self.status
		when "unprocessed"
			return "Order has not yet been processed"
		when "processed"
			return "Order has been completed"
		else
			return "Please contact Capstory Team to ensure this order is processed"
		end
	end

	def admin_status
		case self.status
		when "unprocessed"
			return "This order needs processed"
		when "processed"
			return "This order is complete"
		else
			return "No Status Present - Verify Status"
		end
	end
end
