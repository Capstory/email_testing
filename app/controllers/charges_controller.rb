class ChargesController < ApplicationController
  before_filter :admin_authentication, only: :index
  
  def index
    @charges = Charge.all
  end
  
  def new
    
  end
  
  def create
    # Charge amount in cents
    amount = 49500
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
        description: 'Testing Charges with Stripe',
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
      PaymentMailer.admin_payment_confirmation(customer).deliver
      PaymentMailer.client_payment_confirmation(customer).deliver
      charge = Charge.create(name: customer[:billing_name], email: customer[:email], customer_hash: customer)
      unless charge.save
        problem = "The payment was made but the charge wasn't saved to the database"
        PaymentMailer.admin_error_notification(customer, problem).deliver
      end
      flash[:success] = "Transaction Successful"
      redirect_to payment_thank_you_path(customer_email: customer[:email])
    else
      charge = Charge.create(name: customer[:billing_name], email: customer[:email], customer_hash: customer, error_hash: error_hash)
      problem = charge.save ? "There was an issue with the payment." : "There was an issue with the payment and the charge was not properly saved in the database."
      PaymentMailer.admin_error_notification(customer, problem, error_hash).deliver
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
end