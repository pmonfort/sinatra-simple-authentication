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
          SimpleAuthentication.model_class.first(:id => session[:user])
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

    class << self
      attr_accessor :model_class,
                    :use_password_confirmation,
                    :max_password_length,
                    :min_password_length,
                    :taken_email_message,
                    :missing_email_message,
                    :invalid_email_message,
                    :missing_password_message,
                    :short_password_message,
                    :long_password_message,
                    :missing_password_confirmation_message,
                    :password_confirmation_dont_match_password_message,
                    :login_wrong_email_message,
                    :login_wrong_password_message,
                    :login_successful
    end

    def self.configure(&block)
      yield self
    end

    def self.registered(app)
      #load_user_class will set the corresponding model class
      self.model_class = self.load_user_class
      require "ruby-debug"; debugger; ""
      app.helpers SimpleAuthentication::Helpers

      #Set costum variables
      app.set :use_password_confirmation, use_password_confirmation.nil? ? true : use_password_confirmation
      app.set :min_password_length, min_password_length.nil? ? 4 : min_password_length
      app.set :max_password_length, max_password_length.nil? ? 16 : max_password_length

      app.set :login_wrong_email_message, login_wrong_email_message.nil? ? "The email you entered is incorrect." : login_wrong_email_message
      app.set :login_wrong_password_message, login_wrong_password_message.nil? ? "The password you entered is incorrect." : login_wrong_password_message
      app.set :login_successful, login_successful.nil? ? "Login successful." : login_successful

      #Validations errors messages
      taken_email = taken_email_message.nil? ? "Email is already been taken." : taken_email_message
      missing_email = missing_email_message.nil? ? "Email can't be blank." : missing_email_message
      invalid_email = invalid_email_message.nil? ? "Email invalid format." : invalid_email_message
      missing_password = missing_password_message.nil? ? "Password can't be blank." : missing_password_message
      short_password = short_password_message.nil? ? "Password is too short, must be between #{app.settings.min_password_length} and #{app.settings.max_password_length} characters long." : short_password_message
      long_password = long_password_message.nil? ? "Password is too long, must be between #{app.settings.min_password_length} and #{app.settings.max_password_length} characters long." : long_password_message
      missing_password_confirmation = missing_password_confirmation_message.nil? ? "Password confirmation can't be blank." : missing_password_confirmation_message
      password_confirmation_dont_match_password = password_confirmation_dont_match_password_message.nil? ? "Password confirmation don't match password." : password_confirmation_dont_match_password_message

      app.set :error_messages, { :missing_email => missing_email,
        :taken_email => taken_email,
        :invalid_email => invalid_email,
        :missing_password => missing_password,
        :short_password => short_password,
        :long_password => long_password,
        :missing_password_confirmation => missing_password_confirmation,
        :password_confirmation_dont_match_password => password_confirmation_dont_match_password
      }

      app.set :sinatra_authentication_view_path, File.expand_path('../views/', __FILE__)
      app.enable :sessions

      model_class.settings = app.settings
      model_class.set_validation_rules

      app.get "/signup" do
        @password_confirmation = settings.use_password_confirmation
        @user = SimpleAuthentication.model_class.new
        @actionUrl = ""

        #Try to load an user view otherwise load the default
        begin
          haml :"/signup"
        rescue
          haml get_view_as_string("signup.haml")
        end
      end

      app.post "/signup" do
        @user = SimpleAuthentication.model_class.new
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

        if user = SimpleAuthentication.model_class.first(:email => params[:email])
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
      current_path = File.expand_path("..", __FILE__)

      if Object.const_defined?("DataMapper")
        orm_directory_name = 'datamapper'
        base_module = DataMapper
      elsif Object.const_defined?("ActiveRecord")
        orm_directory_name = 'active_record'
        base_module = ActiveRecord
      else
        throw "Not DataMapper nor ActiveRecord connection detected."
      end

      require File.join(current_path, "models/#{orm_directory_name}/adapter")

      if !base_module::Adapter.model_class
        require File.join(current_path, "models/#{orm_directory_name}/user")
      end

      model_class = base_module::Adapter.model_class
    end
  end
end
