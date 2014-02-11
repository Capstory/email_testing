class Capsule < ActiveRecord::Base
  attr_accessible :name, :email, :event_date, :named_url, :response_message
  
  has_many :encapsulations
  has_many :users, through: :encapsulations
  has_many :posts
  
  validates_uniqueness_of :email
  # validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  extend FriendlyId
  friendly_id :named_url
  def has_pin?
    if self.pin_code.nil?
      return false
    else
      return true
    end
  end
  
  def owners_name
    owner = self.encapsulations.where(owner: true)
    if owner.empty?
      return "N/A"
    else
      return owner.first.user.name
    end
  end
  
  def owner
    owner = self.encapsulations.where(owner: true)
    if owner.empty?
      return "N/A"
    else
      return owner.first.user
    end
  end
end
