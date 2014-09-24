class PageVisit < ActiveRecord::Base
  attr_accessible :original_url, :remote_ip, :trackable_id, :trackable_type

	belongs_to :trackable, polymorphic: true
end
