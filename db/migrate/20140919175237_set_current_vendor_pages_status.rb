class SetCurrentVendorPagesStatus < ActiveRecord::Migration
  def up
	
		vendor_pages = VendorPage.all

		vendor_pages.each do |vp|
			vp.vendor_status = true
			if vp.save
				puts "============================="
				puts "#{vp.name} status set: #{vp.vendor_status}"
			else
				puts "-----------------------------"
				puts "Unable to chang #{vp.name}"
			end
		end
	
  end

  def down
  end
end
