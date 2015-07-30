class AlbumOrdersController < ApplicationController
	before_filter :already_paid?, only: [:quantity, :update, :billing, :order_details, :order_confirmation]

	def index
		@orders = AlbumOrder.all
		render "index", layout: "angular_orders"
	end

	def create
		cookie_name = "#{params[:capsule_name]}_order".to_sym

		if cookies.signed[cookie_name]
			@order = AlbumOrder.find(cookies.signed[cookie_name])
		else
			@order = AlbumOrder.new
		end

		@order.contents = {"selections" => params[:selection_ids], "cover_photo" => params[:cover_photo_id], "capsule_name" => params[:capsule_name]}

		if @order.save
			cookies.signed[cookie_name] = { value: @order.id, expires: 6.hours.from_now }

			respond_to do |format|
				format.json { render json: @order, status: :ok }
			end
		else
			respond_to do |format|
				format.json { render json: @order.errors, status: :error }
			end
		end
	end

	def quantity
		@order = AlbumOrder.find(params[:order_id])
	end

	def update
		quantities = {
			"hard_covers" => {
				"quantity" => params[:hard_cover_quantity].to_i,
				"total" => params[:hard_cover_total].to_f
			},
			"soft_covers" => {
				"quantity" => params[:soft_cover_quantity].to_i,
				"total" => params[:soft_cover_total].to_f
			}
		}
		
		@order = AlbumOrder.find(params[:order_id])
		@order.quantities = quantities
		@order.total = params[:total].to_f
		@order.paid = false

		respond_to do |format|
			if @order.save
				format.json { render json: @order, status: :created }
			else
				format.json { render json: {error: "unable to process"}, status: 500 }
			end
		end
	end

	def update_status
		@order = AlbumOrder.find(params[:id])
		@order.status = params[:status]

		if @order.save
			respond_to do |format|
				format.json { render json: @order }
			end
		else
			respond_to do |format|
				format.json { render json: {msg: "Unable to save status update"} }
			end
		end

	end

	def billing
		@order = AlbumOrder.find(params[:order_id])
	end

	def order_details
		@order = AlbumOrder.find(params[:order_id])	
		@order.update_order_details(params)
		@order.save

		# render "order_details", layout: "application"
	end

	def order_confirmation
		order = AlbumOrder.find(params[:order_id])

		error_hash = {}

		begin
			client = Stripe::Customer.create(
				email: order.email,
				card: order.customer_info["transaction_token"]
			)

			stripe_charge = Stripe::Charge.create(
				customer: client.id,
				amount: (order.total * 100).to_i,
				description: 'Charges with Stripe',
				currency: 'usd'
			)
		rescue Stripe::CardError => e
			error_hash[:card_error] = JSON.parse(e.json_body)
		rescue Stripe::InvalidRequestError => e
			error_hash[:invalid_request_error] = JSON.parse(e.json_body)
		rescue Stripe::AuthenticationError => e
			error_hash[:authentication_error] = JSON.parse(e.json_body)
		rescue Stripe::APIConnectionError => e
			error_hash[:api_connection_error] = JSON.parse(e.json_body)
		rescue Stripe::StripeError => e
			error_hash[:stripe_error] = JSON.parse(e.json_body)
		end

		order.paid = stripe_charge["paid"]
		order.status = "new"
		order.save

		if error_hash.empty?

			cookie_name = "#{order.contents['capsule_name']}_order".to_sym
			cookies.delete cookie_name

			AlbumOrdersMailer.customer_notification(order).deliver
			AlbumOrdersMailer.admin_notification(order).deliver

			flash[:success] = "Transaction Successful"
			redirect_to "/orders/thank_you?order_id=#{ order.id }"
		else
				# charge = Charge.create(name: customer[:full_name], email: customer[:email], customer_hash: customer, error_hash: error_hash)
				# problem = order.save ? "There was an issue with the payment." : "There was an issue with the payment and the charge was not properly saved in the database."
				# PaymentMailer.admin_error_notification(customer, problem, error_hash).deliver

			flash[:error] = "Unable to process the payment."
			redirect_to "/orders/error?order_id=#{ order.id }"
		end
	end
	
	def thank_you
		@customer_email = AlbumOrder.find(params[:order_id]).email
	end

	def northpointe
		if Rails.env.production?
			@capsule_names = {
				"Star" => "star", 
				"Tiny Mini" => "tinymini", 
				"Shining Star" => "shiningstar", 
				"Super Star" => "superstar", 
				"Northpointe Dance" => "northpointedance", 
				"Stellar" => "stellar", 
				"Select Supreme" => "selectsupreme", 
				"Premier" => "premier"
			}
		else
			@capsule_names = {
				"My Capsule" => "submit", 
				"An Empty Capsule" => "emptycapsule",
				"Makarov's Capsule" => "makarov"
			}
		end
	end

	def already_paid
		@order = AlbumOrder.find(params[:order_id])
	end

	def upload
		order = AlbumOrder.find(params[:order_id])

		file = File.new("#{Rails.root}/tmp/#{params[:file_name]}", "wb")
		file.write(request.body.read)
		file.close

		case params[:file_format]
		when "inner"
			order.inner_file = File.open(file.path, "rb")
		when "cover"
			order.cover_photo = File.open(file.path, "rb")
		when "soft_cover"
			order.soft_cover = File.open(file.path, "rb")
		when "soft_inner"
			order.soft_inner = File.open(file.path, "rb")
		end

		File.delete(file.path)

		if order.save
			respond_to do |format|
				format.json { render json: order.to_json(methods: [:soft_inner_url, :soft_cover_url, :inner_file_url, :cover_photo_url]), status: :ok }
			end
		else
			respond_to do |format|
				format.json { render json: {msg: "Unable to save album upload"}, status: :not_acceptable } 
			end
		end
	end

	def delete_upload
		order = AlbumOrder.find(params[:order_id])

		case params[:file_format]
		when "inner"
			order.inner_file = nil
		when "cover"
			order.cover_photo = nil
		when "soft_cover"
			order.soft_cover = nil
		when "soft_inner"
			order.soft_inner = nil
		end

		if order.save
			respond_to do |format|
				format.json { render json: order.to_json(methods: [:soft_inner_url, :soft_cover_url, :inner_file_url, :cover_photo_url]), status: :ok }
			end
		else
			respond_to do |format|
				format.json { render json: { msg: "Unable to delete the file" }, status: :not_accpetable }
			end
		end
	end

	def export_to_xlsx
		orders = AlbumOrder.where("status IS NOT NULL")

		Axlsx::Package.new do |p|
			p.workbook.styles do |s|
				title = s.add_style sz: 16, b: true, alignment: { horizontal: :center, vertical: :center }
				header = s.add_style bg_color: "EFEFEF", sz: 14, b: true, alignment: { horizontal: :center, vertical: :center }, border: { style: :thin, color: "00"}
				p.workbook.add_worksheet(name: "Orders") do |sheet|

					image_path = Rails.root.join("public", "images", "logo.png").to_s
					sheet.add_image(image_src: image_path, noSelect: true, noMove: true, hyperlink: "https://www.capstory.me") do |image|
						image.start_at(0,0)
						image.width = 467
						image.height = 104
						image.hyperlink.tooltip = "Capstory Website"
					end

					sheet.add_row []
					sheet.add_row []
					sheet.add_row []
					sheet.add_row []
					sheet.add_row []
					sheet.add_row []
					sheet.add_row []
					sheet.add_row []
					sheet.add_row []
					sheet.add_row []
					sheet.add_row ["Hard Cover Orders"], style: title
					sheet.add_row xlsx_header_row, style: header
					orders.each do |order|
						sheet.add_row order.to_xlsx_row("hard_covers") if order.hard_cover_quantity > 0
					end

					sheet.add_row []
					sheet.add_row []
					sheet.add_row ["Soft Cover Orders"], style: title
					sheet.add_row xlsx_header_row, style: header
					orders.each do |order|
						sheet.add_row order.to_xlsx_row("soft_covers") if order.soft_cover_quantity > 0
					end
				end
			end

			@file_path = Tempfile.new("my_export.xlsx")
			p.serialize(@file_path)
		end

		send_file(@file_path, filename: "northpointe_orders_export.xlsx", type: "application/xlsx")
	end

	private

	def already_paid?
		order = AlbumOrder.find(params[:order_id])

		if order.paid
			cookie_name = "#{order.contents['capsule_name']}_order".to_sym
			cookies.delete cookie_name

			redirect_to "/orders/already_paid?order_id=#{ order.id }"
		end
	end

	def xlsx_header_row
		["First Name", "Last Name", "Shipping Address", "Description", "Quantity", "Cover", "Inside Pages"]
	end
end
