require 'rubygems'
require 'sinatra/base'
require 'dm-core'
require 'sinatra/simple-authentication'
require 'rack-flash'

class Index < Sinatra::Base
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, 'mysql://' + "USERNAME" + ":" + "PASSWORD" + "@" + "HOST" + "/" + "DATABASE")

  use Rack::Flash
  register Sinatra::SimpleAuthentication
  set :use_password_confirmation, true

  get '/' do
    login_required
    haml :'/home'
  end
end
