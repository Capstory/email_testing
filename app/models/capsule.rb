class Capsule < ActiveRecord::Base
  attr_accessible :name, :email, :event_date, :named_url
  
  has_many :encapsulations
  has_many :users, through: :encapsulations
  has_many :posts
  
  validates_uniqueness_of :email
  # validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  extend FriendlyId
  friendly_id :named_url
  
end
