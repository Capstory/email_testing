class AccessRequest < ActiveRecord::Base
  attr_accessible :email, :event_address, :name
end
