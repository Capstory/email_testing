desc "Delete vendors and all their encapsulations"
task :delete_vendors => [:environment] do
	vendors = User.where(type: "Vendor")

	vendors.each do |vendor|
		vendor.encapsulations.each do |e|
			e.delete
		end

		vendor.delete
	end
end
