class Post < ActiveRecord::Base
  attr_accessible :body, :email, :image

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
