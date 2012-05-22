module Common
  module InstanceMethods
    attr_accessor :password, :password_confirmation

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
