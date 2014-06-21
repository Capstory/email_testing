class RemoveVendorsTable < ActiveRecord::Migration
  def up
		drop_table :vendors
  end

  def down
		create_table :vendors do |t|
			t.string :name
			t.string :partner_code
			t.string :email
			t.string :phone
			t.string :named_url

			t.timestamps
		end
  end
end
