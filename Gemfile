source 'https://rubygems.org'
ruby "2.0.0"
gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
group :development do
  gem 'sqlite3'
end

group :production, :staging do
  gem 'thin'
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  # gem 'zurb-foundation'
  
  # foundation-rails is Foundation version 5. However, I had problems implementing the new version. It would not deploy properly.
  # Thus, I will need to revisit it sometime in the near future.
  gem 'foundation-rails', '5.0.2.0'
  
  gem 'jquery-ui-rails'
  gem 'angularjs-rails'
  
	gem 'stringjs-rails'
end

gem 'will_paginate', '~> 3.0'
gem 'font-awesome-rails'
gem 'friendly_id', '~> 4.0.10.1'

# private_pub is a websockets gem created by Ryan Bates. While I think it is a great idea, 
# I couldn't get if functioning with our current set up. Thus, I have excluded it. 
# However, I may consider revisiting it in the future.
# gem 'private_pub'

gem 'jquery-rails'

# colorbox-rails is deprecated. Now using fancybox2-rails for lightboxes in Capsules.
# gem 'colorbox-rails'
gem 'fancybox2-rails'
gem 'filepicker-rails'

gem "chartkick"

gem 'rmagick'
gem 'paperclip', '3.5.2'
gem 'aws-sdk'
gem 'mail'
gem 'zencoder'

# For authentication -> at present only identity is the only one used for login to site
# Facebook gem is used to log in to FB for photo push
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-identity'

# Koala is used to interact with Facebook for pushing photos
gem 'koala'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# gem 'i18n', "~> 0.6.5"
# gem 'redis-i18n', '~> 0.6.5'

gem 'redis'
gem 'resque', require: "resque/server"
gem 'resque-scheduler', require: "resque_scheduler"

# Stripe gem for controller credit card usage and billing
gem 'stripe', git: 'https://github.com/stripe/stripe-ruby'

# Zip gem for compressing bulk image downloads
gem 'rubyzip'
gem 'axlsx', git: 'https://github.com/randym/axlsx'

# gem 'clockwork'
# To use Jbuilder templates for JSON
# gem 'jbuilder'

group :development do
	gem "letter_opener_web", "~> 1.2.0"
end

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
