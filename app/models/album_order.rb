class AlbumOrder < ActiveRecord::Base
  attr_accessible :address, :contents, :email, :name, :quantities, :total, :customer_info, :paid, :status, :cover_photo, :inner_file

	serialize :address, JSON
	serialize :contents, JSON
	serialize :quantities, JSON
	serialize :customer_info, JSON


	has_attached_file :cover_photo
	validates_attachment :cover_photo, content_type: { content_type: "application/pdf" }

	has_attached_file :inner_file
	validates_attachment :inner_file, content_type: { content_type: "application/pdf" }

	def cover_photo_url
		self.cover_photo.url(:original)
	end

	def inner_file_url
		self.inner_file.url(:original)
	end

	def hard_cover_quantity
		self.quantities["hard_covers"]["quantity"]
	end

	def hard_cover_total
		self.quantities["hard_covers"]["total"]
	end

	def soft_cover_quantity
		self.quantities["soft_covers"]["quantity"]
	end

	def soft_cover_total
		self.quantities["soft_covers"]["total"]
	end

	def update_order_details(params)
		self.email = params[:email]

		self.address = {
			"first_name" => params[:first_name],
			"last_name" => params[:last_name],
			"full_name" => params[:first_name] + " " + params[:last_name],
			"billing_address_1" => params[:same_address] == "yes" ? params[:shipping_address_1] :  params[:billing_address_1],
			"billing_address_2" => params[:same_address] == "yes" ? params[:shipping_address_2] :  params[:billing_address_2],
			"billing_city" => params[:same_address] == "yes" ? params[:shipping_city] :  params[:billing_city],
			"billing_state" => params[:same_address] == "yes" ? params[:shipping_state] :  params[:billing_state],
			"billing_zip" => params[:same_address] == "yes" ? params[:shipping_zip] :  params[:billing_zip],
			"shipping_address_1" => params[:shipping_address_1],
			"shipping_address_2" => params[:shipping_address_2],
			"shipping_city" => params[:shipping_city],
			"shipping_state" => params[:shipping_state],
			"shipping_zip" => params[:shipping_zip]
		}
		
		self.customer_info = {
			"last_4" => params[:last_4],
			"card_type" => params[:card_type],
			"card_expiration" => "#{params[:card_exp_month]}/#{params[:card_exp_year]}",
			"transaction_token" => params[:transaction_token]
		}
	end
end
