require 'rubygems'
require 'sinatra/base'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

require 'dm-core'
require 'sinatra/simple-authentication'
#require 'rack-flash'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://' + "USERNAME" + ":" + "PASSWORD" + "@" + "HOST" + "/" + "DATABASE")

module Sinatra
  class Base
    set :environment, :test
    register Sinatra::SimpleAuthentication
  end
end

class SimpleAuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_sign_up
    get '/signup'
    assert last_response.ok?
    assert true
  end

  def test_int
    assert false
  end

end
