class Encapsulation < ActiveRecord::Base
  attr_accessible :capsule_id, :guest, :owner, :user_id
  
  belongs_to :capsule
  belongs_to :user
end
