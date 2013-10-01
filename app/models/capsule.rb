class Capsule < ActiveRecord::Base
  attr_accessible :name, :email
  
  has_many :encapsulations
  has_many :users, through: :encapsulations
  has_many :posts
end
