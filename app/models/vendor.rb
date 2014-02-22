class Vendor < ActiveRecord::Base
  attr_accessible :email, :name, :named_url, :partner_code, :phone
  
  has_many :vendor_contacts
  
  extend FriendlyId
  friendly_id :named_url
end
