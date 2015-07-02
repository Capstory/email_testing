class DropEntriesTable < ActiveRecord::Migration
	def change
		drop_table :entries
	end
end
