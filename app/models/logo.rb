class Logo < ActiveRecord::Base
  attr_accessible :image, :logoable_id, :logoable_type, :height, :width

	belongs_to :logoable, polymorphic: true

	has_attached_file :image, styles: { standard: "250x250>", small: "100x100>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	def get_image_dimensions(image_url)
		Paperclip::Geometry.from_file(image_url)
	end

	def standard_width
		if self.image.url(:standard).nil?
			nil
		else
			get_image_dimensions(self.image.url(:standard)).width
		end
	end

	def standard_height
		if self.image.url(:standard).nil?
			nil
		else
			get_image_dimensions(self.image.url(:standard)).height
		end
	end
end
