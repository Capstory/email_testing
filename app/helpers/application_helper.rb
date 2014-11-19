module ApplicationHelper

	def logo_url(object)
		return object.logo.image.url(:standard)
	end

	def logo_width(object)
		return object.logo.width || object.logo.standard_width
	end

	def logo_height(object)
		return object.logo.height || object.logo.standard_height
	end

	def logo_padding_top(object)
		padding = object.logo.padding_top || 0
		return padding.to_s + "px"
	end

	def logo_padding_left(object)
		padding = object.logo.padding_left || 0
		return padding.to_s + "px"
	end
end
