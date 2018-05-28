FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    country { Faker::Address.country_code_long.downcase }
    city { Faker::Address.city }
    post_code { Faker::Address.postcode }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
