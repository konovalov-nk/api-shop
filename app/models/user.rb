class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable, :recoverable, :rememberable, :trackable, :validatable,
         jwt_revocation_strategy: self

  validates :first_name, :last_name, presence: true
end
