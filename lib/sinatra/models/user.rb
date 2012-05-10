require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'digest'

class User
  include DataMapper::Resource
  attr_accessor :password, :password_confirmation

  property :id,               Serial
  property :email,            String, :required => true
  property :password_hashed,  String
  property :salt,             String

  class << self
    attr_accessor :settings
  end

  def self.set_validation_rules
    validates_uniqueness_of :email
    validates_format_of :email, :as => :email_address
    validates_with_method :check_password
    validates_length_of :password, :min => self.settings.min_password_length, :max => self.settings.max_password_length

    if self.settings.use_password_confirmation
      validates_confirmation_of :password
    end
  end

  def password=(pass)
    if !pass.strip.empty?
      @password = pass
      self.salt = generate_salt unless self.salt
      self.password_hashed = encrypt(pass, self.salt)
    end
  end

  def generate_salt
    (0..25).inject('') { |r, i| r << rand(93) + 33 }
  end

  def encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt)
  end

  def authenticate(pass)
    encrypt(pass, self.salt) == self.password_hashed
  end

  def check_password
    if @password
      return true
    else
      [false, 'Password must not be blank']
    end
  end
end

User.auto_upgrade!
