class Logo < ActiveRecord::Base
  attr_accessible :image, :logoable_id, :logoable_type, :height, :width

	belongs_to :logoable, polymorphic: true

	has_attached_file :image, styles: { standard: "250x250>", small: "100x100>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
