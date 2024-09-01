class User < ApplicationRecord
  PASSWORD_MIN_LENGTH = 8
  PASSWORD_MAX_LENGTH = 84

  has_secure_password
  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  validates_length_of :password, allow_blank: true, minimum: PASSWORD_MIN_LENGTH, maximum: PASSWORD_MAX_LENGTH, on: [ :create, :update ]
  validates_confirmation_of :password, allow_blank: true, on: :update
end
