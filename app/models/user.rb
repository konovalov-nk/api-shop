class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable, :recoverable, :rememberable, :trackable, :validatable,
         jwt_revocation_strategy: self

  validates :first_name, :last_name, presence: true

  has_many :orders

  def full_name
    "#{self.first_name} #{self.last_name}".chomp
  end

  def country_name
    NormalizeCountry.convert self.country, to: :official
  end
end
