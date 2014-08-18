<<<<<<< HEAD
ENV["RAILS_ENV"] ||= "test"
=======
ENV['RAILS_ENV'] ||= 'test'
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
<<<<<<< HEAD
  ActiveRecord::Migration.check_pending!

=======
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
