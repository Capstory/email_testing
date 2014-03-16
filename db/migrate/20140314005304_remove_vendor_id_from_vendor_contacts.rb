class RemoveVendorIdFromVendorContacts < ActiveRecord::Migration
  def up
    remove_column :vendor_contacts, :vendor_id
  end

  def down
    add_column :vendor_contacts, :vendor_id, :string
  end
end
