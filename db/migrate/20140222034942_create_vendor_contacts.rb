class CreateVendorContacts < ActiveRecord::Migration
  def change
    create_table :vendor_contacts do |t|
      t.string :name
      t.string :email
      t.string :vendor_code
      t.string :address_1
      t.string :address_2
      t.string :phone
      t.text :message
      t.integer :vendor_id

      t.timestamps
    end
  end
end
