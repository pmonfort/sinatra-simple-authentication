# -*- coding: utf-8 -*-

module Sinatra
  module SimpleAuthentication
    require File.join(File.expand_path("..", __FILE__), "simple_authentication/controllers/defaults")
    require File.join(File.expand_path("..", __FILE__), "simple_authentication/controllers/helpers")
    require File.join(File.expand_path("..", __FILE__), "simple_authentication/controllers/session")

    def self.registered(app)
      Sinatra::SimpleAuthentication::Controllers::Session.registered(app)
    end

    def self.require_adapter()
      if Object.const_defined?("DataMapper")
        require File.join(File.expand_path("..", __FILE__), "simple_authentication/models/datamapper/adapter")
      elsif Object.const_defined?("ActiveRecord")
        require File.join(File.expand_path("..", __FILE__), "simple_authentication/models/active_record/adapter")
      else
        throw "Not DataMapper nor ActiveRecord connection detected."
      end
    end

    def self.configure(&block)
      Sinatra::SimpleAuthentication::Controllers::Defaults.configure(&block)
    end
  end
end
