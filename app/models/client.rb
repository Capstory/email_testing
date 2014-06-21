class Client < User
	belongs_to :vendor  

	def via_vendor?
		if self.vendor
			return true
		else
			return false
		end
	end

	def via_direct?
		if self.vendor
			return false
		else
			return true
		end
	end
end
