# -*- coding: utf-8 -*-

module Sinatra
  module SimpleAuthentication
    require File.join(File.expand_path("..", __FILE__), "simple_authentication/controllers/defaults")
    require File.join(File.expand_path("..", __FILE__), "simple_authentication/controllers/helpers")
    require File.join(File.expand_path("..", __FILE__), "simple_authentication/controllers/session")
    def self.configure(&block)
      Sinatra::SimpleAuthentication::Controllers::Defaults.configure(&block)
    end

    def self.registered(app)
      Sinatra::SimpleAuthentication::Controllers::Session.registered(app)
    end
  end
end
