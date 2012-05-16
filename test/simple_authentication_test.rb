require 'rubygems'
require 'sinatra/base'
require 'test/unit'
require 'rack/test'
require 'dm-core'
require 'sinatra/simple-authentication'

module Sinatra
  class Base
    set :environment, :test
    DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup(:default, "sqlite://#{Dir.pwd}/test.db")
    register Sinatra::SimpleAuthentication
  end
end

class SimpleAuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_routes
    get '/signup'
    assert last_response.ok?

    get '/login'
    assert last_response.ok?

    get '/logout'
    assert last_response.ok?
  end
end
