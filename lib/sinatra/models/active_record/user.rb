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

class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  def self.set_validation_rules
    validates_presence_of :email
    validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/
    validates_uniqueness_of :email

    if Proc.new { |t| t.new_record? }
      validates_presence_of :password
      validates_length_of :password, :minimum => self.settings.min_password_length, :maximum => self.settings.max_password_length

      if self.settings.use_password_confirmation
        validates_presence_of :password_confirmation
      end
    end

    if self.settings.use_password_confirmation
      validates_confirmation_of :password
    end
  end

  class << self
    attr_accessor :settings
  end

  def check_password
    if @password
      return true
    else
      [false, 'Password must not be blank']
    end
  end

  def password=(pass)
    if !pass.strip.empty?
      @password = pass
      self.salt = generate_salt unless self.salt
      self.hashed_password = encrypt(pass, self.salt)
    end
  end

  def generate_salt
    (0..25).inject('') { |r, i| r << rand(93) + 33 }
  end

  def encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt)
  end

  def authenticate(pass)
    encrypt(pass, self.salt) == self.hashed_password
  end
end
