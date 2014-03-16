class Vendor < ActiveRecord::Base
  attr_accessible :email, :name, :named_url, :partner_code, :phone
  
  has_many :vendor_contacts, as: :vendor_contactable
  has_many :vendor_employees
  # accepts_nested_attributes_for :vendor_employees, allow_destroy: true
  
  extend FriendlyId
  friendly_id :named_url
end
