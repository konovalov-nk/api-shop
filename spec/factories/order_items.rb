FactoryBot.define do
  factory :order_item do
    product
    order
    quantity { Faker::Number.positive 1, 20 }
  end
end
