Rails.configuration.stripe = {
  if !Rails.env.production?
    publishable_key: 'pk_test_kHdS86KoSOZw7gp811b2qCxj',
    secret_key: 'sk_test_DfmIwlYRxxBoM2GWapZ8XJkp'
  else
    publishable_key: ENV["STRIPE_PK"],
    secret_key: ENV["STRIPE_SECRET"]
  end
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]