class AddVendorStatusToVendorPages < ActiveRecord::Migration
  def change
    add_column :vendor_pages, :vendor_status, :boolean
  end
end
