module ApplicationHelper

	def show_user_name
		if current_user
			!current_user.name.blank? ? "Signed in as #{current_user.name}" : "Signed in as Private User"
		else
			"Guest Visitor"	
		end
	end

	def logo_url(object)
		return object.logo.image.url(:standard).gsub("http", "https")
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
