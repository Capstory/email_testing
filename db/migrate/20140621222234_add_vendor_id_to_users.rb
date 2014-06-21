class AddVendorIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vendor_id, :integer
  end
end
