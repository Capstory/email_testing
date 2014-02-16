if Rails.env.production?
  Rails.configuration.stripe = {
      publishable_key: ENV["STRIPE_PK"],
      secret_key: ENV["STRIPE_SECRET"]
  }
else
  Rails.configuration.stripe = {
      publishable_key: 'pk_test_kHdS86KoSOZw7gp811b2qCxj',
      secret_key: 'sk_test_DfmIwlYRxxBoM2GWapZ8XJkp'
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]