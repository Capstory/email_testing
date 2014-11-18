class VendorPage < ActiveRecord::Base
  attr_accessible :email, :name, :named_url, :partner_code, :phone, :vendor_status

  has_many :vendor_contacts, as: :vendor_contactable
  has_many :vendor_employees
  # accepts_nested_attributes_for :vendor_employees, allow_destroy: true

	has_many :page_visits, as: :trackable
	has_one :logo, as: :logoable
  
  extend FriendlyId
  friendly_id :named_url

	def verified?
		self.vendor_status ? true : false
	end	

	def has_logo?
		self.logo.blank?
	end
end
