require "ostruct"

class ChargesController < ApplicationController
	before_filter :admin_authentication, only: :index
	# force_ssl if: :in_production?, only: [:new, :create]
	layout "homepages"

	def index
		@charges = Charge.all
	end

	def new
		# @contact_form = ContactForm.new
		# @test_program_visit = params[:tpv] ? true : false
	end

	def alt_new
		case params[:package]
		when "bronze"
			package_price = 499
		when "silver"
			package_price = 799
		when "gold"
			package_price = 1499
		else
			package_price = 799
		end
		@package = {name: params[:package], price: package_price }
		render "alt_new", layout: "application" 
	end

	def order_details
		# Charge amount in cents
		customer = {}
		customer[:amount] = params[:package_price].to_i * 100	
		customer[:package] = params[:package_name]
		customer[:email] = params[:email]
		customer[:first_name] = params[:first_name]
		customer[:last_name] = params[:last_name]
		customer[:full_name] = params[:first_name] + " " + params[:last_name]
		customer[:billing_address_1] = params[:same_address] == "yes" ? params[:shipping_address_1] :  params[:billing_address_1]
		customer[:billing_address_2] = params[:same_address] == "yes" ? params[:shipping_address_2] :  params[:billing_address_2]
		customer[:billing_city] = params[:same_address] == "yes" ? params[:shipping_city] :  params[:billing_city]
		customer[:billing_state] = params[:same_address] == "yes" ? params[:shipping_state] :  params[:billing_state]
		customer[:billing_zip] = params[:same_address] == "yes" ? params[:shipping_zip] :  params[:billing_zip]
		customer[:shipping_address_1] = params[:shipping_address_1]
		customer[:shipping_address_2] = params[:shipping_address_2]
		customer[:shipping_city] = params[:shipping_city]
		customer[:shipping_state] = params[:shipping_state]
		customer[:shipping_zip] = params[:shipping_zip]
		customer[:last_4] = params[:last_4]
		customer[:card_type] = params[:card_type]
		customer[:card_expiration] = "#{params[:card_exp_month]}/#{params[:card_exp_year]}"
		customer[:transaction_token] = params[:transaction_token]

		# raise customer.to_yaml
		@customer = OpenStruct.new(customer)
		render "order_details", layout: "application"
	end

	def order_confirm
		customer = JSON.parse(params[:customer], {symbolize_names: true})[:table]
		p customer
		# raise customer.to_yaml

		error_hash = {}

		begin
			client = Stripe::Customer.create(
				email: customer[:email],
				card: customer[:transaction_token]
			)

			stripe_charge = Stripe::Charge.create(
				customer: client.id,
				amount: customer[:amount],
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

		customer[:success] = stripe_charge["paid"]


		if error_hash.empty?
				charge = Charge.create(name: customer[:full_name], email: customer[:email], customer_hash: customer)
				PaymentMailer.admin_payment_confirmation(customer).deliver
				PaymentMailer.client_payment_confirmation(customer).deliver

				unless charge.save
					problem = "The payment was made but the charge wasn't saved to the database"
					PaymentMailer.admin_error_notification(customer, problem).deliver
				end
			# else
			# 	charge = Charge.create(name: customer[:full_name], email: customer[:email], customer_hash: customer, is_test: true)
			# 	unless charge.save
			# 		raise "The payment went through fine but there was an error somewhere else"
			# 	end
			# end

			flash[:success] = "Transaction Successful"
			redirect_to payment_thank_you_path(customer_email: customer[:email])
		else
			# if Rails.env.production?
				charge = Charge.create(name: customer[:full_name], email: customer[:email], customer_hash: customer, error_hash: error_hash)
				problem = charge.save ? "There was an issue with the payment." : "There was an issue with the payment and the charge was not properly saved in the database."
				PaymentMailer.admin_error_notification(customer, problem, error_hash).deliver
			# else
			# 	charge = Charge.create(name: customer[:full_name], email: customer[:email], customer_hash: customer, error_hash: error_hash, is_test: true)
			# 	unless charge.save
			# 		raise "There was an issue with both the payment and saving the charge"
			# 	end
			# end

			flash[:error] = "Unable to process the payment."
			redirect_to payment_error_path(customer_email: customer[:email])
		end
	end


	def create
		# Charge amount in cents
		amount = 50000
		error_hash = {}
		customer = {}
		customer[:amount] = amount    
		customer[:email] = params[:stripeEmail]
		customer[:billing_name] = params[:stripeBillingName]
		customer[:billing_address_1] = params[:stripeBillingAddressLine1]
		customer[:billing_address_2] = params[:stripeBillingAddressLine2]
		customer[:billing_city] = params[:stripeBillingAddressCity]
		customer[:billing_state] = params[:stripeBillingAddressState]
		customer[:billing_zip] = params[:stripeBillingAddressZip]
		customer[:billing_country] = params[:stripeBillingAddressCountry]
		customer[:shipping_name] = params[:stripeShippingName]
		customer[:shipping_address_1] = params[:stripeShippingAddressLine1]
		customer[:shipping_address_2] = params[:stripeShippingAddressLine2]
		customer[:shipping_city] = params[:stripeShippingAddressCity]
		customer[:shipping_state] = params[:stripeShippingAddressState]
		customer[:shipping_zip] = params[:stripeShippingAddressZip]
		customer[:shipping_country] = params[:stripeShippingAddressCountry]

		begin
			client = Stripe::Customer.create(
				email: params[:stripeEmail],
				card: params[:stripeToken]
			)

			stripe_charge = Stripe::Charge.create(
				customer: client.id,
				amount: amount,
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

		customer[:last_4] = stripe_charge["card"]["last4"]
		customer[:card_type] = stripe_charge["card"]["type"]
		customer[:success] = stripe_charge["paid"]


		if error_hash.empty?
			if Rails.env.production?
				charge = Charge.create(name: customer[:billing_name], email: customer[:email], customer_hash: customer)
				PaymentMailer.admin_payment_confirmation(customer).deliver
				PaymentMailer.client_payment_confirmation(customer).deliver

				unless charge.save
					problem = "The payment was made but the charge wasn't saved to the database"
					PaymentMailer.admin_error_notification(customer, problem).deliver
				end
			else
				charge = Charge.create(name: customer[:billing_name], email: customer[:email], customer_hash: customer, is_test: true)
				unless charge.save
					raise "The payment went through fine but there was an error somewhere else"
				end
			end

			flash[:success] = "Transaction Successful"
			redirect_to payment_thank_you_path(customer_email: customer[:email])
		else
			if Rails.env.production?
				charge = Charge.create(name: customer[:billing_name], email: customer[:email], customer_hash: customer, error_hash: error_hash)
				problem = charge.save ? "There was an issue with the payment." : "There was an issue with the payment and the charge was not properly saved in the database."
				PaymentMailer.admin_error_notification(customer, problem, error_hash).deliver
			else
				charge = Charge.create(name: customer[:billing_name], email: customer[:email], customer_hash: customer, error_hash: error_hash, is_test: true)
				unless charge.save
					raise "There was an issue with both the payment and saving the charge"
				end
			end

			flash[:error] = "Unable to process the payment."
			redirect_to payment_error_path(customer_email: customer[:email])
		end
	end

	def thank_you
		@customer_email = params[:customer_email]
	end

	def payment_error
		@customer_email = params[:customer_email]
	end

	# def in_production?
	#   Rails.env.production?
	# end
end
