# -*- coding: utf-8 -*-

require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'digest'
require 'sinatra/simple-authentication'

class User
  include DataMapper::Resource
  Sinatra::SimpleAuthentication.require_adapter

  include Sinatra::SimpleAuthentication::Models::DataMapper::Adapter
  property :first_name, DataMapper::Property::String
  property :last_name, DataMapper::Property::String

  validates_presence_of :first_name, :message => "Missing First name"
  validates_uniqueness_of :first_name, :scope => :last_name,
    :message => "There's already a user with that first name and last name"
end

User.auto_upgrade!
