require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'digest'

class DmUser
  include DataMapper::Resource
  include DataMapper::Adapter
end

DmUser.auto_upgrade!
