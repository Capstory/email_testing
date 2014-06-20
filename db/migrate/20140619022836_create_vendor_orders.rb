class CreateVendorOrders < ActiveRecord::Migration
  def change
    create_table :vendor_orders do |t|
      t.integer :vendor_id
      t.string :requested_address
      t.string :email
      t.date :event_date
      t.text :requested_upgrades
      t.string :shipping_1
      t.string :shipping_2
      t.string :shipping_city
      t.string :shipping_state
      t.string :shipping_zip
      t.string :client_names

      t.timestamps
    end
  end
end
