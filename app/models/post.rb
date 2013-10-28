class Post < ActiveRecord::Base
  attr_accessible :body, :email, :image, :capsule_id

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "200x200>" }
  
  belongs_to :capsule
end
