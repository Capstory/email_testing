class CreateVendorPages < ActiveRecord::Migration
  def change
    create_table :vendor_pages do |t|
      t.string :name
      t.string :partner_code
      t.string :email
      t.string :phone
      t.string :named_url

      t.timestamps
    end
    
    vendors = Vendor.all
    count = vendors.length
    
    vendors.each do |vendor|
      vp = VendorPage.create(name: vendor.name, partner_code: vendor.partner_code, email: vendor.email, phone: vendor.phone, named_url: vendor.named_url)
      count -= 1
      if vp.save
        puts "Vendor Transferred"
        puts "Vendor Name: #{vp.name}"
        puts "Vendor Email: #{vp.email}"
        puts "#{count} Vendors Left"
        puts "=========================="
      else
        puts "Unable to Transfer Vendor"
        puts "Vendor Name: #{vendor.name}"
        puts "Vendor Email: #{vendor.email}"
        puts "=========================="
      end
    end
  end
end
