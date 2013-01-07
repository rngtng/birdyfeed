source 'http://rubygems.org'

gem 'rails', '3.2.9'

gem 'thin'
gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
# group :assets do
#   gem 'sass-rails',   '~> 3.1.5'
#   gem 'coffee-rails', '~> 3.1.1'
#   gem 'uglifier', '>= 1.0.3'
# end

gem 'phonie'
# , {
#   :git => "git://github.com/wmoxam/phone.git"
# }

gem 'jquery-rails'

# Access to Carddav
gem 'net_dav', {
  # :git => "git://github.com/devrandom/net_dav.git" # to get access to 'properties'
  :git => "git://github.com/rngtng/net_dav.git" # to get access to 'properties'
}
gem 'curb'

# To Parse vcards
gem 'vcard'
# gem 'event-calendar', :require => 'event_calendar'


group :development, :test do
  gem 'rspec-rails'
end

group :development do
  gem 'debugger'
  gem 'foreman'
end

group :test do
  # fixtures
  # gem 'faker'
  gem 'factory_girl_rails'
  # gem 'timecop'

  # Integration
  # gem 'capybara'
  # gem 'database_cleaner'

  gem 'shoulda-matchers' # e.g. for "respond_with"
  # gem 'diffy'

  # Productivity
  # gem 'livereload'
  # gem 'guard-rspec' # https://github.com/guard/guard
  # gem 'watchr'
  # gem 'spork', '~> 1.0rc'

  # Coverage
  # gem 'simplecov'

  gem 'vcr'

  # Check on simple scrurity flaws:
  # gem 'brakeman'

  # Speed up AR Test?!
  # gem 'nulldb'
end
