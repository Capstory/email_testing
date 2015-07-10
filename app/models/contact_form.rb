class ContactForm < ActiveRecord::Base
  attr_accessible :email, :message, :name, :source
  
  # validates_presence_of :email
  # validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

	def self.compose_request_demo_message(params)
		%Q{
			Someone has requested a demo. Below is the information from the contact form:
			-------------------------------------

			Name: #{ params[:name] }
			Email/Phone Number: #{ params[:email] }
			Company: #{ params[:company] }
			Position/Title: #{ params[:position] }

			Event Type: #{ params[:event_type] }
			Event Date: #{ params[:event_date] }
			Event Size: #{ params[:event_size] }

			Feature Interests:
			Live Streaming: #{ feature_interest?(params[:live_streaming])}
			Custom Branding: #{ feature_interest?(params[:branding]) }
			Photo Aggregation: #{ feature_interest?(params[:aggregation]) }
			Custom Books: #{feature_interest?(params[:custom_books]) }

			Additional Information:
			#{ params[:additional_information] }
		}
	end

	def self.compose_request_package_information_message(msg_info_hash, genre)
		case genre
		when "request_package_information"
			request_package_information_message(msg_info_hash)
		when "corporate_quote"
			corporate_quote_message(msg_info_hash)
		when "receptions_addon"
			receptions_add_message(msg_info_hash)
		end
	end

	def self.request_package_information_message(msg_info_hash)
		%Q{
				Below is a message from a request for more information concerning our packages:
				---------------------------------
				
				Additional Interests:
				Books - #{ ContactForm.package_interest?(msg_info_hash[:books]) }	
				Extra Cards - #{ ContactForm.package_interest?(msg_info_hash[:extra_cards]) }	
				Video Montage - #{ ContactForm.package_interest?(msg_info_hash[:video_montage]) }	
				Other - #{ ContactForm.package_interest?(msg_info_hash[:other]) }	

				----------------------------------

				Event Date: #{ msg_info_hash[:event_date] }

				Additional Message:

				#{ msg_info_hash[:message] }

		}
	end

	# def self.request_package_information_message(msg_info_hash)
	# 	%Q{
	# 			Below is a message from a request for more information concerning our packages:
	# 			---------------------------------
				
	# 			Packages Interest:
	# 			Bronze - #{ ContactForm.package_interest?(msg_info_hash[:bronze_package]) }	
	# 			Silver - #{ ContactForm.package_interest?(msg_info_hash[:silver_package]) }	
	# 			Gold - #{ ContactForm.package_interest?(msg_info_hash[:gold_package]) }	
	# 			Custom Package - #{ ContactForm.package_interest?(msg_info_hash[:custom_package]) }	

	# 			----------------------------------

	# 			Event Date: #{ msg_info_hash[:event_date] }

	# 			Additional Message:

	# 			#{ msg_info_hash[:message] }

	# 		}
	# end

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

	def self.receptions_add_message(msg_info_hash)
		%Q{
				Someone has submitted an order for Journey by Receptions

				Below are the details of the order:
				-----------------------------------------

				Phone Number: #{ msg_info_hash[:phone_number] }
				Event Date: #{ msg_info_hash[:event_date] }
				Event Location: #{ msg_info_hash[:event_location] }
				Message: #{ msg_info_hash[:message] }
			}
	end

	def self.package_interest?(package_value)
		package_value.nil? ? "No" : "Yes"
	end

	def self.feature_interest?(feature)
		feature.nil? ? "No" : "Yes"
	end
end
