require 'rubygems'
require 'sinatra/base'
require 'dm-core'
require 'sinatra/simple-authentication'

class Index < Sinatra::Base
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, 'mysql://' + "root" + ":" + "3578" + "@" + "localhost" + "/" + "simple_authentication_dev")

  register Sinatra::SimpleAuthentication
  set :use_password_confirmation, true

  get '/' do
    login_required
    haml :'/home'
  end
end
