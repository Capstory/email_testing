Rails.configuration.stripe = {
  publishable_key: 'pk_test_kHdS86KoSOZw7gp811b2qCxj',
  secret_key: 'sk_test_DfmIwlYRxxBoM2GWapZ8XJkp'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]