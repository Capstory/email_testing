if Rails.env.production?
  Rails.configuration.stripe = {
      publishable_key: ENV["STRIPE_PK"],
      secret_key: ENV["STRIPE_SECRET"]
  }
elsif Rails.env.staging?
  Rails.configuration.stripe = {
    publishable_key: ENV['STRIPE_TEST_PK'],
    secret_key: ENV['STRIPE_TEST_SECRET']
  }
else
  Rails.configuration.stripe = {
      publishable_key: ENV['STRIPE_TEST_PK'],
      secret_key: ENV['STRIPE_TEST_SECRET']
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
