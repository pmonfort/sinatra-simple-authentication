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
  register Sinatra::SimpleAuthentication

  get '/' do
    login_required
    haml :'/home'
  end
end
