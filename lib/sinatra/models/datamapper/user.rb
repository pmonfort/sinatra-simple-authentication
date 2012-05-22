require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'digest'
require File.join(File.expand_path("..", __FILE__), 'adapter')

class User
  include DataMapper::Resource
  include DataMapper::Adapter
end

User.auto_upgrade!
