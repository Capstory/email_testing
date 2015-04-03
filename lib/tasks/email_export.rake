desc "Export data from Code for a Cause Application"
task :export_model => [:environment] do |t, args|
	require "csv"

	model = ENV["model_name"].constantize
	model_attributes = model.accessible_attributes.to_a.delete_if { |e| e.blank? }

	instances = model.all
	temp_file = Tempfile.new("export_file.csv")

	csv_array = CSV.generate do |csv|
		instances.each do |element|
				acc = []

				model_attributes.each do |attribute|
					acc << element[attribute]
				end

				csv_array << acc
		end
	end
	
	temp_file.write(csv_array)
	temp_file.close
	
	EmailExporterMailer.send_export(temp_file.path, ENV["email_address"]).deliver

	temp_file.unlink
end
