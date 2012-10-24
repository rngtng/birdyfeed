source 'http://rubygems.org'

gem 'rails', '3.2.8'

gem 'thin'
gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
# group :assets do
#   gem 'sass-rails',   '~> 3.1.5'
#   gem 'coffee-rails', '~> 3.1.1'
#   gem 'uglifier', '>= 1.0.3'
# end

gem 'jquery-rails'

# Access to Carddav
gem 'net_dav'
gem 'curb'

# To Parse vcards
gem 'vcard'

gem 'event-calendar', :require => 'event_calendar'


group :development do
  gem 'foreman'

  # Deploy with Capistrano
  gem 'capistrano'
  gem 'heroku'
end

group :development, :test do
  gem 'rspec-rails'
  # gem 'debugger'
end

group :test do
  # Pretty printed test output
  # gem 'turn', '0.8.2', :require => false
  gem 'factory_girl_rails' # problems with bazooka
end
