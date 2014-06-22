class VendorOrder < ActiveRecord::Base
  attr_accessible :client_names, :email, :event_date, :requested_address, :requested_upgrades, :shipping_1, :shipping_2, :shipping_city, :shipping_state, :shipping_zip, :vendor_id

	belongs_to :vendor
end
