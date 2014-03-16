class CreateVendorEmployees < ActiveRecord::Migration
  def change
    create_table :vendor_employees do |t|
      t.string :name
      t.integer :vendor_id
      t.string :partner_code
      t.string :email
      t.string :phone
      t.string :named_url

      t.timestamps
    end
  end
end
