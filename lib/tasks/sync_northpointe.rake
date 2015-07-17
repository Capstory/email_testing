desc "Sync the photos for Northpointe that are already in the templates"
task :sync_northpointe => [:environment] do
	require "csv"

	# csv = CSV.read("#{Rails.root}/lib/assets/output.csv")

end	
