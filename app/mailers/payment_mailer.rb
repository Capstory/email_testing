class PaymentMailer < ActionMailer::Base
  default from: "hello@capstory.me", 
          reply_to: "hello@capstory.me"
          
  def client_payment_confirmation(customer)
    @customer = customer
    mail(to: @customer[:email], subject: "Capstory Payment Confirmation")
  end
  
  def admin_payment_confirmation(customer)
    @customer = customer
    mail(to: "hello@capstory.me", subject: "Customer Payment Confirmation")
  end
  
  def admin_error_notification(customer, problem, error_hash = nil)
    @customer = customer
    @problem = problem
    @error_hash = error_hash
    mail(to: ["dustin@capstory.me", "suprasanna@capstory.me", "jocelyn@capstory.me", "brad@capstory.me"], subject: "There was a problem with a recent charge")
  end
end