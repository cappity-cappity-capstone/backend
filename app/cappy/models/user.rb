require 'bcrypt'

module Cappy
  module Models
    # This model represents the state of a connected device
    class User < ActiveRecord::Base
      self.table_name = 'users'

      validates :username,  presence: true
      validates :password_hash,      presence: true

      def password
        @password ||= BCrypt::Password.new(password_hash)
      end

      def password=(new_password)
        @password = BCrypt::Password.create(new_password)
        self.password_hash = @password
      end
    end
  end
end
