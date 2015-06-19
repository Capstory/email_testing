class AlbumOrdersController < ApplicationController
	before_filter :already_paid?, only: [:quantity, :update, :billing, :order_details, :order_confirmation]

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

		if error_hash.empty?
				# charge = Charge.create(name: customer[:full_name], email: customer[:email], customer_hash: customer)
				# PaymentMailer.admin_payment_confirmation(customer).deliver
				# PaymentMailer.client_payment_confirmation(customer).deliver

			unless order.save
				problem = "The payment was made but the charge wasn't saved to the database"
				# PaymentMailer.admin_error_notification(customer, problem).deliver
			end

			cookie_name = "#{order.contents['capsule_name']}_order".to_sym
			cookies.delete cookie_name

			flash[:success] = "Transaction Successful"
			redirect_to "/orders/thank_you?order_id=#{ order.id }"
		else
				# charge = Charge.create(name: customer[:full_name], email: customer[:email], customer_hash: customer, error_hash: error_hash)
				problem = order.save ? "There was an issue with the payment." : "There was an issue with the payment and the charge was not properly saved in the database."
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
				"An Awesome Cap" => "awesomecap",
				"Makarov's Capsule" => "makarov"
			}
		end
	end

	def already_paid
		@order = AlbumOrder.find(params[:order_id])
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
end
