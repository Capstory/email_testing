if Rails.env.production?
  Rails.configuration.stripe = {
      publishable_key: ENV["STRIPE_PK"],
      secret_key: ENV["STRIPE_SECRET"]
  }
elsif Rails.env.staging?
  Rails.configuration.stripe = {
    publishable_key: 'pk_test_ZlkeBvAftG6vS2HujXewCy1N',
    secret_key: 'sk_test_He5y6CBip4iH7hcvZua6C8sk'
  }
else
  Rails.configuration.stripe = {
      publishable_key: 'pk_test_kHdS86KoSOZw7gp811b2qCxj',
      secret_key: 'sk_test_DfmIwlYRxxBoM2GWapZ8XJkp'
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]