# -*- coding: utf-8 -*-

require 'rubygems'
require 'active_record'
require 'digest'

module Sinatra
  module SimpleAuthentication
    module Models
      module ActiveRecord
        unless ::ActiveRecord::Base.connection.table_exists?("ar_users")
          class CreateUsers < ::ActiveRecord::Migration
            def self.up
              create_table :ar_users do |t|
                t.string :email
                t.string :hashed_password
                t.string :salt
                #t.timestamps
              end

              add_index :ar_users, :email, :unique => true
            end

            def self.down
              remove_index :ar_users, :email
              drop_table :ar_users
            end
          end

          CreateUsers.up
        end

        class ArUser < ::ActiveRecord::Base
          include Adapter
        end
      end
    end
  end
end
