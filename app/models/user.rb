class User < ApplicationRecord
  has_secure_password

  has_many :user_groups
  has_many :groups, through: :user_groups

  validates :username, presence: true
  validates :email, presence: true
end
