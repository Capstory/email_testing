class ContactForm < ActiveRecord::Base
  attr_accessible :email, :message, :name, :source
  
  validates_presence_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

	def self.compose_request_package_information_message(msg_info_hash, genre)
		case genre
		when "request_package_information"
			request_package_information_message(msg_info_hash)
		when "corporate_quote"
			corporate_quote_message(msg_info_hash)
		end
	end

	def self.request_package_information_message(msg_info_hash)
		%Q{
				Below is a message from a request for more information concerning our packages:
				---------------------------------
				
				Packages Interest:
				Bronze - #{ ContactForm.package_interest?(msg_info_hash[:bronze_package]) }	
				Silver - #{ ContactForm.package_interest?(msg_info_hash[:silver_package]) }	
				Gold - #{ ContactForm.package_interest?(msg_info_hash[:gold_package]) }	
				Custom Package - #{ ContactForm.package_interest?(msg_info_hash[:custom_package]) }	

				----------------------------------

				Event Date: #{ msg_info_hash[:event_date] }

				Additional Message:

				#{ msg_info_hash[:message] }

			}
	end

	def self.corporate_quote_message(msg_info_hash)
		%Q{
				Below is a message from the corporate page requesting a quote:
				---------------------------------
				
				Type of Events:
				Corporate Retreat - #{ ContactForm.package_interest?(msg_info_hash[:corporate_retreat]) }
				Conference - #{ ContactForm.package_interest?(msg_info_hash[:conference]) }
				Company Party - #{ ContactForm.package_interest?(msg_info_hash[:company_party]) }
				Custom Package - #{ ContactForm.package_interest?(msg_info_hash[:custom_package]) }

				----------------------------------

				Event Date: #{ msg_info_hash[:event_date] }

				Additional Message:

				#{ msg_info_hash[:message] }

			}
	end

	def self.package_interest?(package_value)
		package_value.nil? ? "No" : "Yes"
	end
end
