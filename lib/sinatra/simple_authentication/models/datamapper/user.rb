# -*- coding: utf-8 -*-

require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'digest'

module Sinatra
  module SimpleAuthentication
    module Models
      module DataMapper
        class DmUser
          include ::DataMapper::Resource
          include Adapter
        end

        DmUser.auto_upgrade!
      end
    end
  end
end
