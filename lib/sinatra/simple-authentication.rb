require "rubygems"
require "sequel"
require 'haml'
require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/content_for'
#require File.expand_path("../models/user", __FILE__)
require_relative 'models/user'

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
          User.get(:id => session[:user])
        else
          return false
        end
      end

      def logged_in?
        !!session[:user]
      end
    end

    def self.registered(app)
      app.helpers SimpleAuthentication::Helpers
      app.helpers Sinatra::ContentFor
      app.register Sinatra::ConfigFile
      app.config_file 'settings.yml'

      app.get "/signup" do
        @password_confirmation = settings.simple_authorization["password_confirmation"]
        @user = User.new
        #@actionUrl = "#{settings.simple_authorization["base_url"]}/signup"
        @actionUrl = ""
        haml :"signup"
      end

      app.post "/signup" do
        @user = User.new
        @user.email = params[:email]
        @user.password = params[:password]
        @user.password_confirmation = params[:password_confirmation]

        begin
          raise 'Invalid model' unless @user.valid?
          @user.save
          redirect '/admin'
        rescue => e
          @password_confirmation = settings.simple_authorization["password_confirmation"]
          @errors = @user.errors
          haml :"signup"
        end
      end

      app.get "/login" do
        if !!session[:user]
          redirect '/'
        else
          haml :"login"
        end
      end

      app.post "/login" do
        if user = User.authenticate(params[:email], params[:password])
          session[:user] = user.id

          if Rack.const_defined?('Flash')
            flash[:notice] = "Login successful."
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
            flash[:notice] = "The email or password you entered is incorrect."
          end
          redirect '/login'
        end
      end

      app.get '/logout' do
        session[:user] = nil
        if Rack.const_defined?('Flash')
          flash[:notice] = "Logout successful."
        end
        redirect '/'
      end
    end
  end

  register SimpleAuthentication
end
