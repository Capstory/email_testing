class RemoveVendorRelatedTables < ActiveRecord::Migration
	def change
		drop_table :vendor_pages
		drop_table :vendor_contacts
		drop_table :vendor_employees
		drop_table :vendor_orders
	end
end
