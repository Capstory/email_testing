class Charge < ActiveRecord::Base
  attr_accessible :customer_hash, :error_hash, :email, :name
  
  serialize :customer_hash
  serialize :error_hash
end
