module VendorPagesHelper
	def logo_url(vendor)
		return vendor.logo.image.url(:standard)
	end

	def logo_width(vendor)
		return vendor.logo.width || vendor.logo.standard_width
	end

	def logo_height(vendor)
		return vendor.logo.height || vendor.logo.standard_height
	end

	def logo_padding_top(vendor)
		padding = vendor.logo.padding_top || 0
		return padding.to_s + "px"
	end

	def logo_padding_left(vendor)
		padding = vendor.logo.padding_left || 0
		return padding.to_s + "px"
	end
end
