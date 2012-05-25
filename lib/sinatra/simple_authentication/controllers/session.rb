# -*- coding: utf-8 -*-

require "rubygems"
require 'haml'
require 'sinatra/base'

module Sinatra
  module SimpleAuthentication
    module Controllers
      module Session
        class << self
          attr_accessor :base_path,
                        :model_class
        end

        self.base_path = File.expand_path("../..", __FILE__)

        def self.registered(app)
          require File.join(self.base_path, "controllers/defaults")
          #load_user_class will set the corresponding model class
          Session.model_class = self.load_user_class
          app.helpers Helpers
          app = Defaults.setDefaults(app)
          Session.model_class.settings = app.settings
          Session.model_class.set_validation_rules

          app.get "/signup" do
            @password_confirmation = settings.use_password_confirmation
            @user = Session.model_class.new
            @actionUrl = ""

            #Try to load an user view otherwise load the default
            begin
              haml :"/signup"
            rescue
              haml get_view_as_string("signup.haml")
            end
          end

          app.post "/signup" do
            @user = Session.model_class.new
            @user.email = params[:email]
            @user.password = params[:password]
            @user.password_confirmation = params[:password_confirmation]

            if @user.save
              redirect '/'
            else
              @password_confirmation = settings.use_password_confirmation
              if Rack.const_defined?('Flash')
                if Object.const_defined?("DataMapper")
                  flash[:error] = @user.errors.full_messages
                else
                  flash[:error] = @user.errors.to_a
                end
              end

              #Try to load a local user view otherwise load the default
              begin
                haml :"/signup"
              rescue
                haml get_view_as_string("signup.haml")
              end
            end
          end

          app.get "/login" do
            if !!session[:user]
              redirect '/'
            else
              #Try to load a local user view otherwise load the default
              begin
                haml :"/login"
              rescue
                haml get_view_as_string("login.haml")
              end
            end
          end

          app.post "/login" do
            if user = Session.model_class.first(:email => params[:email])
              if user.authenticate(params[:password])
                session[:user] = user.id
                if Rack.const_defined?('Flash')
                  flash[:notice] = [app.settings.login_successful]
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
                  flash[:error] = [app.settings.login_wrong_password_message]
                end
              end
            else
              if Rack.const_defined?('Flash')
                flash[:error] = [app.settings.login_wrong_email_message]
              end
            end
            redirect '/login'
          end

          app.get '/logout' do
            session[:user] = nil
            redirect '/'
          end
        end

        def self.load_user_class
          if Object.const_defined?("DataMapper")
            orm_directory_name = 'datamapper'
            base_module = DataMapper
          elsif Object.const_defined?("ActiveRecord")
            orm_directory_name = 'active_record'
            base_module = ActiveRecord
          else
            throw "Not DataMapper nor ActiveRecord connection detected."
          end

          require File.join(self.base_path, "models/#{orm_directory_name}/adapter")

          if !base_module::Adapter.model_class
            require File.join(self.base_path, "models/#{orm_directory_name}/user")
          end

          base_module::Adapter.model_class
        end
      end
    end
  end
end
