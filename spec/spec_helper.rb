
  # if ENV["COV"]
  #   require 'simplecov'
  #   SimpleCov.start 'rails'
  # end

ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

module Rack
  module Test

    class Session
      def propfind(uri, params = {}, env = {}, &block)
        env = env_for(uri, env.merge(:method => "PROPFIND", :params => params))
        process_request(uri, env, &block)
      end
    end

    module Methods
      def propfind(uri, params = {}, env = {}, &block)
        current_session.propfind(uri, params, env, &block)
      end
    end

  end
end

module AcceptanceHelper
  include Rack::Test::Methods

end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = true

  config.treat_symbols_as_metadata_keys_with_true_values = true
end
