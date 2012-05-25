# -*- coding: utf-8 -*-

require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'digest'

class User
  include DataMapper::Resource
  include DataMapper::Adapter
end

User.auto_upgrade!
