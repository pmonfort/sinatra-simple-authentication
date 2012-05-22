require File.join(File.expand_path("../../common", __FILE__), 'instance_methods')

module ActiveRecord
  module Adapter
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        include ActiveRecord::Adapter::InstanceMethods
      end
    end

    module ClassMethods
      attr_accessor :settings

      def set_validation_rules
        validates_presence_of :email, :message => self.settings.error_messages[:missing_email]
        validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/, :message => self.settings.error_messages[:invalid_email]
        validates_uniqueness_of :email, :message => self.settings.error_messages[:taken_email]

        if Proc.new { |t| t.new_record? }
          validates_presence_of :password, :message => self.settings.error_messages[:missing_password]
          validates_length_of :password, :minimum => self.settings.min_password_length, :message => self.settings.error_messages[:short_password]
          validates_length_of :password, :maximum => self.settings.max_password_length, :message => self.settings.error_messages[:long_password]

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
