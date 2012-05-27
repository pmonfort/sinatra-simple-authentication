# -*- coding: utf-8 -*-

require 'rubygems'
require 'active_record'
require 'digest'

module Sinatra
  module SimpleAuthentication
    module Models
      module ActiveRecord
        unless ::ActiveRecord::Base.connection.table_exists?("users")
          class CreateUsers < ::ActiveRecord::Migration
            def self.up
              create_table :users do |t|
                t.string :email
                t.string :hashed_password
                t.string :salt

                t.string :first_name
                t.string :last_name
                #t.timestamps
              end

              add_index :users, :email, :unique => true
            end

            def self.down
              remove_index :users, :email
              drop_table :users
            end
          end

          CreateUsers.up
        end

        class User < ::ActiveRecord::Base
          Sinatra::SimpleAuthentication.require_adapter
          include Sinatra::SimpleAuthentication::Models::ActiveRecord::Adapter

          validates_presence_of :first_name, :message => "Missing First name"
          validates_uniqueness_of :first_name, :scope => :last_name,
            :message => "There's already a user with that first name and last name"
        end
      end
    end
  end
end
