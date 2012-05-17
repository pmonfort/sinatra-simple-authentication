require 'rubygems'
require 'sinatra/base'
require 'test/unit'
require 'rack/test'
require 'dm-core'
require 'sinatra/simple-authentication'
require 'nokogiri'

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

  def test_signup_page
    get '/signup'
    assert last_response.ok?

    html = Nokogiri::HTML(last_response.body)
    assert html.css('[name="email"]')
    assert html.css('[name="password"]')
    assert html.css('[name="password_confirmation"]')
  end

  def test_login_page
    get '/login'
    assert last_response.ok?

    html = Nokogiri::HTML(last_response.body)
    assert html.css('[name="email"]')
    assert html.css('[name="password"]')

    #get '/logout'
    #assert last_response.ok?
  end

  def test_user_validations
    user = User.new
    assert !user.save

    assert user.errors.include?(["Email must not be blank"])
    assert user.errors.include?(["Password must not be blank"])
    assert user.errors.include?(["Password must be between 4 and 16 characters long"])

    #Short password
    user = User.new
    user.password = "tt"
    assert !user.save
    assert user.errors.include?(["Password must be between 4 and 16 characters long", "Password does not match the confirmation"])
    assert user.errors.include?(["Email must not be blank"])

    #Long password
    user = User.new
    user.password = "tttttttttttttttttttttttttttt"
    assert !user.save
    assert user.errors.include?(["Password must be between 4 and 16 characters long", "Password does not match the confirmation"])
    assert user.errors.include?(["Email must not be blank"])

    #Wrong format email
    user = User.new
    user.email = "tttttttttttttt"
    assert !user.save
    assert user.errors.include?(["Email has an invalid format"])
    assert user.errors.include?(["Password must not be blank"])
    assert user.errors.include?(["Password must be between 4 and 16 characters long"])

    #Valid user
    user = User.new
    user.email = "test@mail.com"
    user.password = "PASSWORD"
    user.password_confirmation = "PASSWORD"
    assert user.save
  end
end
