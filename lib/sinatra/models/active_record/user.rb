require 'rubygems'
require 'active_record'
require 'digest'

unless ActiveRecord::Base.connection.table_exists?("users")
  class CreateUsers < ActiveRecord::Migration
    def self.up
      create_table :users do |t|
        t.string :email
        t.string :hashed_password
        t.string :salt
#        t.timestamps
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

class ArUser < ActiveRecord::Base
  include ActiveRecord::Adapter
end
