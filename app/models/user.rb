class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable, :recoverable, :rememberable, :trackable, :validatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
end
