require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'digest'

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
    current_user = User.first(:email => email)
    return nil if current_user.nil?
    return current_user if self.encrypt(pass, current_user.salt) == current_user.password_hashed
    nil
  end

  def check_password
    if @password
      return true
    else
      [false, 'Password must not be blank']
    end
  end
end
