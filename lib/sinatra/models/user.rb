require 'rubygems'
require 'sequel'
require 'digest'

class User < Sequel::Model
  attr_writer :password_confirmation
  plugin :validation_helpers
  plugin :timestamps, :create => :created_at

  def validate
    super
    Sequel::Plugins::ValidationHelpers::DEFAULT_OPTIONS.merge!(:presence=>{:message=>'cannot be empty'})

    email_regexp = /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i

    validates_presence :email
    validates_presence :password_hashed if new?
    validates_format email_regexp, :email
    validates_unique :email
    errors.add :passwords, ' don\'t match' unless @password == @password_confirmation
  end

  def password=(pass)
    @password = pass
    if !pass.strip.empty?
      self.salt = generate_salt unless self.salt
      self.password_hashed = User.encrypt(pass, self.salt)
    end
  end

  def generate_salt
    (0..25).inject('') { |r, i| r << rand(93) + 33 }
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt)
  end

  def self.authenticate(email, pass)
    current_user = User[:email => email]

    require "ruby-debug"; debugger; ""
    return nil if current_user.nil?
    return current_user if self.encrypt(pass, current_user.salt) == current_user.password_hashed
    nil
  end
end
