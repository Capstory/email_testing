class AddStatusToVendorOrders < ActiveRecord::Migration
  def change
    add_column :vendor_orders, :status, :string
  end
end
