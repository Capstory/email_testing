class VendorContact < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :email, :message, :name, :phone, :vendor_code
  
  belongs_to :vendor_contactable, polymorphic: true
  
  def get_vendor
    return  self.vendor_contactable_type.constantize.find(self.vendor_contactable_id)
  end
end
