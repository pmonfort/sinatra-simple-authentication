# -*- coding: utf-8 -*-

require 'rubygems'
require 'sinatra/base'
require 'active_record'
require 'sinatra/simple-authentication'
require 'rack-flash'

class Index < Sinatra::Base
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "#{Dir.pwd}/example.db")

  use Rack::Flash, :sweep => true
  register Sinatra::SimpleAuthentication

  get '/' do
    login_required
    haml :'/home'
  end
end
