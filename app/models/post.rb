class Post < ActiveRecord::Base
  attr_accessible :body, :email, :image, :capsule_id, :filepicker_url, :tag_for_deletion, :verified

  has_attached_file :image, :styles => { :large => "450x450>", :medium => "300x300>", :thumb => "100x100>", :small => "200x200>", :capsule_height => "x350", :capsule_width => "350x", :lightbox_width => "1024x" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  # validates_attachment_file_name :image, matches: [/./]
  # validates_attachment_size :image, greater_than: 10.kilobytes
  # do_not_validate_attachment_file_type :image
  belongs_to :capsule
  has_one :video

	scope :verified, -> { where(verified: true, tag_for_deletion: false) }
	scope :not_yet_verified, -> { where(verified: false) }
end
