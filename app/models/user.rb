class User < ApplicationRecord
  has_secure_password
  validates :age, presence: true
  validates :email, :username, uniqueness: true
  validates :password, length: { minimum: 6 }
  has_many :articles
  has_many :comments
end
