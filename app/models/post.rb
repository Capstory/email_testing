class Post < ActiveRecord::Base
  attr_accessible :body, :email, :image, :capsule_id, :filepicker_url

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "200x200>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  # validates_attachment_file_name :image, matches: [/./]
  # validates_attachment_size :image, greater_than: 10.kilobytes
  # do_not_validate_attachment_file_type :image
  belongs_to :capsule
  has_one :video
end
