module DmAdapter
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      base.property :id,               DataMapper::Property::Serial
      base.property :email,            DataMapper::Property::String
      base.property :hashed_password,  DataMapper::Property::String
      base.property :salt,             DataMapper::Property::String
      include DmAdapter::InstanceMethods
    end
  end

  module ClassMethods
    attr_accessor :settings

    def set_validation_rules
      validates_presence_of :email
      validates_uniqueness_of :email
      validates_format_of :email, :as => :email_address
      validates_with_method :check_password
      validates_length_of :password, :min => self.settings.min_password_length, :max => self.settings.max_password_length

      if self.settings.use_password_confirmation
        validates_confirmation_of :password
      end
    end
  end

  module InstanceMethods
    attr_accessor :password, :password_confirmation

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
end
