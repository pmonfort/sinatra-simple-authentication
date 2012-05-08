require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'digest'
require 'dm-migrations'

class User
  include DataMapper::Resource
  attr_accessor :password, :password_confirmation

  property :id,               Serial
  property :email,            String, :required => true
  property :password_hashed,  String
  property :salt,             String

  validates_uniqueness_of :email
  validates_format_of :email, :as => :email_address
  validates_with_method :check_password
  validates_confirmation_of :password

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
