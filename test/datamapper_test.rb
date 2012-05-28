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

  def teardown
    Sinatra::SimpleAuthentication::Controllers::Session.model_class.all.destroy
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
  end

  def test_user_validations
    taken_email = "Email has already been taken."
    missing_email = "Email can't be blank."
    invalid_email = "Invalid email format."
    missing_password = "Password can't be blank."
    short_password = "Password is too short, must be between 4 and 16 characters long."
    long_password = "Password is too long, must be between 4 and 16 characters long."

    #Empty user
    user = Sinatra::SimpleAuthentication::Controllers::Session.model_class.new

    assert !user.save
    assert user.errors[:email].include?(missing_email)
    assert user.errors[:password].include?(missing_password)
    assert user.errors[:password].include?(short_password)

    #Short password
    user = Sinatra::SimpleAuthentication::Controllers::Session.model_class.new
    user.password = "X" * 3

    assert !user.save
    assert user.errors[:email].include?(missing_email)
    assert user.errors[:password].include?(short_password)

    #Long password
    user = Sinatra::SimpleAuthentication::Controllers::Session.model_class.new
    user.password = "X" * 17

    assert !user.save
    assert user.errors[:email].include?(missing_email)
    assert user.errors[:password].include?(long_password)

    #Wrong format email
    user = Sinatra::SimpleAuthentication::Controllers::Session.model_class.new
    user.email = "InvaidEmailFormat"

    assert !user.save
    assert user.errors[:email].include?(invalid_email)
    assert user.errors[:password].include?(missing_password)
    assert user.errors[:password].include?(short_password)

    #Valid user
    user = Sinatra::SimpleAuthentication::Controllers::Session.model_class.new
    user.email = "test@mail.com"
    user.password = "PASSWORD"
    user.password_confirmation = "PASSWORD"
    assert user.save

    #user_class duplicated email
    user = Sinatra::SimpleAuthentication::Controllers::Session.model_class.new
    user.email = "test@mail.com"
    user.password = "PASSWORD"
    user.password_confirmation = "PASSWORD"

    assert !user.save
    assert user.errors[:email].include?(taken_email)
  end
end
