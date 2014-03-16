class AddVendorContactableToVendorContacts < ActiveRecord::Migration
  def change
    add_column :vendor_contacts, :vendor_contactable_id, :integer
    add_column :vendor_contacts, :vendor_contactable_type, :string
  end
end
