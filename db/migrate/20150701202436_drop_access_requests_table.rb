class DropAccessRequestsTable < ActiveRecord::Migration
	def change
		drop_table :access_requests
	end
end
