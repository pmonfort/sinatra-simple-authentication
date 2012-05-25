# -*- coding: utf-8 -*-

require File.join(File.expand_path("../../common", __FILE__), 'instance_methods')

module Sinatra
  module SimpleAuthentication
    module Models
      module DataMapper
        module Adapter
          class << self; attr_accessor :model_class; end

          def self.included(base)
            self.model_class = base
            base.extend ClassMethods
            base.class_eval do
              base.property :id,               ::DataMapper::Property::Serial
              base.property :email,            ::DataMapper::Property::String
              base.property :hashed_password,  ::DataMapper::Property::String
              base.property :salt,             ::DataMapper::Property::String
              include InstanceMethods
            end
          end

          module ClassMethods
            attr_accessor :settings

            def set_validation_rules
              validates_presence_of :email, :message => self.settings.error_messages[:missing_email]
              validates_uniqueness_of :email, :message => self.settings.error_messages[:taken_email]
              validates_format_of :email, :as => :email_address, :message => self.settings.error_messages[:invalid_email]

              if Proc.new { |t| t.new_record? }
                validates_presence_of :password, :message => self.settings.error_messages[:missing_password]
                validates_length_of :password, :min => self.settings.min_password_length, :message => self.settings.error_messages[:short_password]
                validates_length_of :password, :max => self.settings.max_password_length, :message => self.settings.error_messages[:long_password]

                if self.settings.use_password_confirmation
                  validates_presence_of :password_confirmation, :message => self.settings.error_messages[:missing_password_confirmation]
                end
              end

              if self.settings.use_password_confirmation
                validates_confirmation_of :password, :message => self.settings.error_messages[:password_confirmation_dont_match_password]
              end
            end
          end

          module InstanceMethods
            include Common::InstanceMethods
          end
        end
      end
    end
  end
end
