# -*- coding: utf-8 -*-

require 'rubygems'
require 'sinatra/base'
require 'dm-core'
require 'sinatra/simple-authentication'
require 'rack-flash'

class Index < Sinatra::Base
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, "sqlite://#{Dir.pwd}/example.db")

  use Rack::Flash, :sweep => true

  #Setup optional settings
  Sinatra::SimpleAuthentication.configure do |c|
    c.use_password_confirmation = false
    c.min_password_length = 4
    c.max_password_length = 16
    c.taken_email_message = "Custom taken email"
    c.missing_email_message = "Custom missing email"
    c.invalid_email_message = "Custom invalid email"
    c.missing_password_message = "Custom missing password"
    c.short_password_message = "Custom short password"
    c.long_password_message = "Custom long password"
    c.missing_password_confirmation_message = "Custom missing password confirmation"
    c.password_confirmation_dont_match_password_message = "Custom don't match password and confirmation"
    c.login_wrong_email_message = "Custom wrong email"
    c.login_wrong_password_message = "Custom wrong password"
    c.login_successful = "Custom Login successful"
  end

  register Sinatra::SimpleAuthentication

  get '/' do
    login_required
    haml :'/home'
  end
end
