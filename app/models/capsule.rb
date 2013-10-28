class Capsule < ActiveRecord::Base
  attr_accessible :name, :email, :event_date
  
  has_many :encapsulations
  has_many :users, through: :encapsulations
  has_many :posts
end
