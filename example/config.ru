ENV["RACK_ENV"] ||= "development"
#
# require 'bundler'
# Bundler.setup
#
# Bundler.require(:default, ENV["RACK_ENV"].to_sym)
#
# Dir["./lib/**/*.rb"].each { |f| require f }

# require 'bundler/setup'
# Bundler.require(:default)

root = File.dirname(__FILE__)
require File.join( root, 'index' )

run Rack::URLMap.new({
  "/"   => Index
})
