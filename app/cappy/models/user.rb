require 'bcrypt'

module Cappy
  module Models
    # This model represents the state of a connected device
    class User < ActiveRecord::Base
      self.table_name = 'users'

      validates :username, presence: true, uniqueness: true
      validates :password_hash, presence: true

      def password
        @password ||= BCrypt::Password.new(password_hash)
      end

      def password=(new_password)
        if new_password.nil?
          # BCrypt::Password constructor creates a random hash if secret is nil.
          # We want to reset the password if no password is passed in.
          @password = nil
          self.password_hash = nil
        else
          @password = BCrypt::Password.create(new_password)
          self.password_hash = @password
        end
      end
    end
  end
end
