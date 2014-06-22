class Vendor < User 
	has_many :clients
	has_many :vendor_orders
end
