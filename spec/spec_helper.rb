# encoding: utf-8
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__)

STDERR.puts("Running Specs under Ruby Version #{RUBY_VERSION}")

gem 'rails', '2.3.18'
require 'initializer'

require 'rspec'

require 'ruby-saml'
require 'saml_idp'

require 'timecop'

Time.zone = 'UTC'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"

  config.include SamlRequestMacros
  config.include SecurityHelpers

  config.before do
    SamlIdp.configure do |c|
      c.attributes = {
        :emailAddress => {
          :name => "email-address",
          :getter => lambda { |p| "foo@example.com" }
        }
      }

      c.name_id.formats = {
        "1.1" => {
          :email_address => lambda { |p| "foo@example.com" }
        }
      }
    end
  end
end
