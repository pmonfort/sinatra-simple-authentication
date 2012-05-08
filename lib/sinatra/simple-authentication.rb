require "rubygems"
require 'haml'
require 'sinatra/base'

module Sinatra
  module SimpleAuthentication
    module Helpers
      def hash_to_query_string(hash)
        hash.collect {|k,v| "#{k}=#{v}"}.join('&')
      end

      def login_required
        if !!current_user
          return true
        else
          session[:return_to] = request.fullpath
          redirect '/login'
          return false
        end
      end

      def current_user
        if !!session[:user]
          User.first(:id => session[:user])
        else
          return false
        end
      end

      def logged_in?
        !!session[:user]
      end

      #BECAUSE sinatra 9.1.1 can't load views from different paths properly
      def get_view_as_string(filename)
        view = File.join(settings.sinatra_authentication_view_path, filename)
        data = ""
        f = File.open(view, "r")
        f.each_line do |line|
          data += line
        end
        return data
      end
    end

    DEFAULTS = {
      :use_password_confirmation => true
    }

    def self.registered(app)
      require_relative 'models/user'
      app.helpers SimpleAuthentication::Helpers
      app.set self::DEFAULTS
      app.enable :sessions
      app.set :sinatra_authentication_view_path, File.expand_path('../views/', __FILE__)

      app.get "/signup" do
        @password_confirmation = settings.use_password_confirmation
        @user = User.new
        @actionUrl = ""
        haml get_view_as_string("signup.haml")
      end

      app.post "/signup" do
        @user = User.new
        @user.email = params[:email]
        @user.password = params[:password]
        @user.password_confirmation = params[:password_confirmation]

        if @user.save
          redirect '/'
        else
          @password_confirmation = settings.use_password_confirmation
          if Rack.const_defined?('Flash')
            flash[:error] = @user.errors.full_messages
          end

          haml get_view_as_string("signup.haml")
        end
      end

      app.get "/login" do
        if !!session[:user]
          redirect '/'
        else
          haml get_view_as_string("login.haml")
        end
      end

      app.post "/login" do
        if user = User.first(:email => params[:email])
          if user.authenticate(params[:password])
            session[:user] = user.id

            if Rack.const_defined?('Flash')
              flash[:notice] = ["Login successful."]
            end

            if !!session[:return_to]
              redirect_url = session[:return_to]
              session[:return_to] = false
              redirect redirect_url
            else
              redirect '/'
            end
          else
            if Rack.const_defined?('Flash')
              flash[:error] = ["The password you entered is incorrect."]
            end
          end
        else
          if Rack.const_defined?('Flash')
            flash[:error] = ["The email you entered is incorrect."]
          end
        end
        redirect '/login'
      end

      app.get '/logout' do
        session[:user] = nil
        redirect '/'
      end
    end
  end
end
