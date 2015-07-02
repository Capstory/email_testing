class DropEngagedContacts < ActiveRecord::Migration
	def change
		drop_table :engaged_contacts
	end
end
