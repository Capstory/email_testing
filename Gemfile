source 'https://rubygems.org'
ruby "1.9.2"
gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
group :development do
  gem 'sqlite3'
end

group :production do
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
  gem 'zurb-foundation'
  
  # foundation-rails is Foundation version 5. However, I had problems implementing the new version. It would not deploy properly.
  # Thus, I will need to revisit it sometime in the near future.
  # gem 'foundation-rails'
  
  gem 'jquery-ui-rails'
end

gem 'font-awesome-rails'
gem 'friendly_id'

# private_pub is a websockets gem created by Ryan Bates. While I think it is a great idea, 
# I couldn't get if functioning with our current set up. Thus, I have excluded it. 
# However, I may consider revisiting it in the future.
# gem 'private_pub'

gem 'jquery-rails'

# colorbox-rails is deprecated. Now using fancybox2-rails for lightboxes in Capsules.
# gem 'colorbox-rails'
gem 'fancybox2-rails'
gem 'filepicker-rails'

gem 'rmagick'
gem 'paperclip'
gem 'aws-sdk'
gem 'mail'

gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-identity'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# gem 'i18n', "~> 0.6.5"
# gem 'redis-i18n', '~> 0.6.5'

gem 'redis'
gem 'resque', require: "resque/server"
gem 'resque-scheduler', require: "resque_scheduler"

# gem 'clockwork'
# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
