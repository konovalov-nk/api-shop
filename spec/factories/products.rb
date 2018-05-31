FactoryBot.define do
  factory :product do
    title { Faker::Commerce.product_name }
    price { Faker::Commerce.price }
    description { Faker::Food.ingredient }
    image_url { Faker::Internet.url }
  end
end
