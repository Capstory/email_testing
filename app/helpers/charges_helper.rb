module ChargesHelper
	def struct_to_json(struct)
		struct.to_json
	end

	def package_name_prep(package)
		package.split("_").join(" ")
	end
end
