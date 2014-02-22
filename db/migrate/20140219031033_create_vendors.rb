class CreateVendors < ActiveRecord::Migration
  def change
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
