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
  end

  register Sinatra::SimpleAuthentication

  get '/' do
    login_required
    haml :'/home'
  end
end
