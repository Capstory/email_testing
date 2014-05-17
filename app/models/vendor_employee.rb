class VendorEmployee < ActiveRecord::Base
  attr_accessible :email, :name, :named_url, :partner_code, :phone, :vendor_page_id
  
  belongs_to :vendor_page
  has_many :vendor_contacts, as: :vendor_contactable
  
  extend FriendlyId
  friendly_id :named_url
end
