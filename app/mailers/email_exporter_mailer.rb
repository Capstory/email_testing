class EmailExporterMailer < ActionMailer::Base
	default from: "hello@capstory.me"

	def send_export(temp_file_path, to_address)
		attachments["email_export.csv"] = File.read(temp_file_path)
		mail(to: to_address, subject: "Here is your export")
	end
end
