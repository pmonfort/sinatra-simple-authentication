# -*- coding: utf-8 -*-

module Sinatra
  module SimpleAuthentication
    module Controllers
      module Defaults
        class << self
          attr_accessor :use_password_confirmation,
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
                        :login_successful_message
        end

        def self.configure(&block)
          yield self
        end

        def self.setDefaults(app)
          app.set :sinatra_authentication_view_path, File.expand_path(File.join("../..", "views"), __FILE__)
          app.enable :sessions

          #Set costum variables
          app.set :use_password_confirmation, use_password_confirmation.nil? ? false : use_password_confirmation
          app.set :min_password_length, min_password_length.nil? ? 4 : min_password_length
          app.set :max_password_length, max_password_length.nil? ? 16 : max_password_length

          app.set :login_wrong_email_message, login_wrong_email_message.nil? ? "Wrong email address." : login_wrong_email_message
          app.set :login_wrong_password_message, login_wrong_password_message.nil? ? "Wrong password." : login_wrong_password_message
          app.set :login_successful_message, login_successful_message.nil? ? "Login successful." : login_successful_message

          #Validations errors messages
          taken_email = taken_email_message.nil? ? "Email has already been taken." : taken_email_message
          missing_email = missing_email_message.nil? ? "Email can't be blank." : missing_email_message
          invalid_email = invalid_email_message.nil? ? "Invalid email format." : invalid_email_message
          missing_password = missing_password_message.nil? ? "Password can't be blank." : missing_password_message
          short_password = short_password_message.nil? ? "Password is too short, must be between #{app.settings.min_password_length} and #{app.settings.max_password_length} characters long." : short_password_message
          long_password = long_password_message.nil? ? "Password is too long, must be between #{app.settings.min_password_length} and #{app.settings.max_password_length} characters long." : long_password_message
          missing_password_confirmation = missing_password_confirmation_message.nil? ? "Password confirmation can't be blank." : missing_password_confirmation_message
          password_confirmation_dont_match_password = password_confirmation_dont_match_password_message.nil? ? "Password confirmation doesn't match password." : password_confirmation_dont_match_password_message

          app.set :error_messages, { :missing_email => missing_email,
            :taken_email => taken_email,
            :invalid_email => invalid_email,
            :missing_password => missing_password,
            :short_password => short_password,
            :long_password => long_password,
            :missing_password_confirmation => missing_password_confirmation,
            :password_confirmation_dont_match_password => password_confirmation_dont_match_password
          }

          app
        end
      end
    end
  end
end

