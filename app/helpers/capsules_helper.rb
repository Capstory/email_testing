module CapsulesHelper
	def get_logo_path(capsule)
		if capsule.has_logo?
			logo_url(capsule)
		else
			asset_path("logo_cream.png")
		end
	end
end
