# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

<<<<<<< HEAD
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])


=======
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
