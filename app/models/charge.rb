class Charge < ActiveRecord::Base
  attr_accessible :customer_hash, :error_hash, :email, :name, :is_test
  
  serialize :customer_hash
  serialize :error_hash
end
